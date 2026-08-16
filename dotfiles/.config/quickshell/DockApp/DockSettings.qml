pragma Singleton

import Quickshell
import Quickshell.Io

// The dock's settings file, its parsed contents and the writes back into it.
//
// This lives outside DockWindow because the "enabled" flag decides whether a
// DockWindow exists at all: DockLoader reads it here to instantiate the dock
// (or not), and the dock IPC — which has to work while the dock is disabled —
// writes it here.
Singleton {
    id: root

    // Same two-file scheme as the status bar:
    //
    //   1. ~/.config/ml4w-dock/dock.json     — the user override. While this
    //      file exists it is the master: every value is read from it and the
    //      pin/unpin actions write their changes back into it.
    //   2. ~/.config/ml4w/settings/dock.json — the shipped fallback, used only
    //      when the override is absent. It carries the dynamic state (enabled,
    //      autohide and the pinned app list).
    //
    // The master file is merged over the built-in defaults, so a partial or
    // entirely missing file still leaves every value defined. DockApp/dock.json
    // documents these defaults and must be kept in sync with them.
    readonly property var defaultSettings: ({
        "dock":   { "enabled": true, "autohide": false, "iconSize": 32,
                    "spacing": 8, "marginBottom": 10, "reserveSpace": true,
                    "hideDelay": 400 },
        "pill":   { "radius": 16, "padding": 12, "animationDuration": 350 },
        "border": { "width": 2, "colorTop": "", "colorBottom": "" },
        "opacity":{ "normal": 0.7 },
        "apps":   { "pinned": [] }
    })

    property var settings: defaultSettings

    readonly property bool enabled: settings.dock.enabled
    readonly property bool autohide: settings.dock.autohide

    // True while the user override file is present. Decides which file is the
    // master for both reads (applySettings) and writes (persistPinned etc.).
    property bool overrideExists: false

    // Both settings files have reported back (loaded or missing), so `settings`
    // holds the values from disk rather than the built-in defaults.
    //
    // DockLoader waits for this before creating the dock. The files report
    // asynchronously, so without the gate the window is built from the defaults
    // — autohide off, space reserved — and only corrects itself a moment later.
    // Hyprland does not reliably pick up the exclusive zone dropping back to 0
    // that soon after the layer surface is created, which leaves an autohiding
    // dock holding a 76px gap open at the bottom of the screen for the session.
    readonly property bool ready: overrideResolved && settingsResolved
    property bool overrideResolved: false
    property bool settingsResolved: false

    FileView {
        id: overrideFile
        path: Quickshell.env("HOME") + "/.config/ml4w-dock/dock.json"
        blockLoading: true
        printErrors: false
        // The resolved flags are set last, after the values are in place: they
        // release DockLoader, and a binding fires the moment it is assigned.
        onLoaded: {
            root.overrideExists = true
            root.applySettings()
            root.overrideResolved = true
        }
        onLoadFailed: {
            root.overrideExists = false
            root.applySettings()
            root.overrideResolved = true
        }
    }

    FileView {
        id: settingsFile
        path: Quickshell.env("HOME") + "/.config/ml4w/settings/dock.json"
        blockLoading: true
        onLoaded: { root.applySettings(); root.settingsResolved = true }
        onLoadFailed: { root.applySettings(); root.settingsResolved = true }
    }

    function masterFile() {
        return root.overrideExists ? overrideFile : settingsFile
    }

    function reloadSettings(): void {
        overrideFile.reload()
        settingsFile.reload()
        console.log("Dock reload: re-reading dock settings")
        applySettings()
    }

    // Parse a settings document that may carry a /* ... */ comment block and —
    // being hand-edited — trailing commas, which strict JSON.parse rejects.
    // Returns undefined when the text is empty or unparseable. Never throws.
    function parseSettings(src) {
        if (!src)
            return undefined
        let raw = src.replace(/\/\*[\s\S]*?\*\//g, "")
        if (raw.trim() === "")
            return undefined
        try {
            return JSON.parse(raw)
        } catch (e) {
            try {
                return JSON.parse(raw.replace(/,(\s*[}\]])/g, "$1"))
            } catch (e2) {
                console.warn("dock settings: could not parse a file,"
                    + " ignoring it:", e2)
                return undefined
            }
        }
    }

    // Merge one settings document (as text) over an already-built settings
    // object, key by key. Empty or unparseable text is ignored so a
    // missing/partial file never clears previously merged values.
    function mergeSettings(merged, src): void {
        let parsed = parseSettings(src)
        if (parsed === undefined)
            return
        for (let group in parsed)
            for (let key in parsed[group])
                if (merged[group] !== undefined)
                    merged[group][key] = parsed[group][key]
    }

    // Rebuild the settings object: built-in defaults with the master file merged
    // on top. An explicit masterText can be passed (e.g. right after a write) so
    // the merge does not depend on the FileView buffer having refreshed yet.
    function applySettings(masterText): void {
        let merged = JSON.parse(JSON.stringify(root.defaultSettings))
        let text = (masterText !== undefined) ? masterText : root.masterFile().text()
        mergeSettings(merged, text)
        root.settings = merged
    }

    // Persist a dock.<key> boolean into the master file and return the updated
    // text. A regex replace keeps the file's formatting and comments intact when
    // the key is already present; otherwise the parsed document is rewritten. An
    // unparseable, non-empty file is left untouched rather than overwritten.
    function persistDockFlag(key, on): string {
        let file = root.masterFile()
        let src = file.text()
        let re = new RegExp('("' + key + '"\\s*:\\s*)(true|false)')
        let updated
        if (re.test(src)) {
            updated = src.replace(re, "$1" + (on ? "true" : "false"))
        } else {
            let obj = root.parseSettings(src)
            if (obj === undefined && src && src.trim() !== "") {
                console.warn("dock settings: master file is not valid JSON;"
                    + " leaving it untouched instead of overwriting.")
                return src
            }
            if (typeof obj !== "object" || obj === null)
                obj = {}
            if (obj.dock === undefined)
                obj.dock = {}
            obj.dock[key] = on
            updated = JSON.stringify(obj, null, 4) + "\n"
        }
        file.setText(updated)
        return updated
    }

    // Persist the pinned app list into the master file. Unlike the boolean flags
    // this always rewrites the JSON document (an array cannot be patched in
    // place with a regex without mangling hand-formatted files), so a comment
    // block in the master file is lost on the first pin/unpin. An unparseable,
    // non-empty file is left untouched.
    function persistPinned(list): void {
        let file = root.masterFile()
        let src = file.text()
        let obj = root.parseSettings(src)
        if (obj === undefined && src && src.trim() !== "") {
            console.warn("dock settings: master file is not valid JSON;"
                + " not writing the pinned list.")
            return
        }
        if (typeof obj !== "object" || obj === null)
            obj = {}
        if (obj.apps === undefined)
            obj.apps = {}
        obj.apps.pinned = list
        let updated = JSON.stringify(obj, null, 4) + "\n"
        file.setText(updated)
        applySettings(updated)
    }

    function setEnabled(on: bool): void {
        applySettings(persistDockFlag("enabled", on))
    }

    function setAutohide(on: bool): void {
        applySettings(persistDockFlag("autohide", on))
    }
}
