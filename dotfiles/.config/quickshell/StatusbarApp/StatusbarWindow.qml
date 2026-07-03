import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import qs.CustomTheme

PanelWindow {
    id: root

    // --- WAYLAND CONFIGURATION ---
    WlrLayershell.layer: WlrLayer.Top
    // Keyboard focus is owned by the HyprlandFocusGrab below (the same primitive
    // the Calendar/Power popups use), not by the layer-shell focus mode. A
    // WlrKeyboardFocus.Exclusive grab held the keyboard until Escape and left
    // running apps dead; OnDemand never grabbed from the keybinding at all. The
    // focus grab gives the bar the keyboard while expanded *and* fires onCleared
    // when the pointer/keyboard goes to another window, which is what hands focus
    // back to the app (and collapses the bar). Leave the layer-shell mode at its
    // default (None) so the two mechanisms don't fight.

    // Grabs the keyboard for the bar while it is expanded so SUPER + SPACE can
    // drive Left/Right/Return navigation, and releases it the moment the user
    // interacts with another window (clicking/entering an app) — which returns
    // the keyboard to that app and collapses the bar.
    HyprlandFocusGrab {
        windows: [root]
        active: root.barExpanded
        onCleared: root.barExpanded = false
    }

    // --- USER SETTINGS ---
    // One of two files is the "master" that feeds the settings object below:
    //
    //   1. ~/.config/ml4w-statusbar/statusbar.json — the user override. When this
    //      file EXISTS it is the master: every value is read from it and the
    //      Sidebar switches write their changes (enabled / alwaysExpanded) back
    //      into it. The shipped file is ignored while it exists.
    //   2. ~/.config/ml4w/settings/statusbar.json — the shipped fallback, used
    //      only when the override file is absent. It carries the dynamic state
    //      the SidebarApp writes (bar.enabled and bar.alwaysExpanded).
    //
    // The active master file is merged over the built-in defaults, so a partial
    // or entirely missing file still leaves every value defined.
    readonly property var defaultSettings: ({
        "bar":    { "height": 40, "reservedHeight": 72, "enabled": true, "alwaysExpanded": false },
        "pill":   { "collapsedWidth": 0, "expandedWidth": 680, "radius": 12, "animationDuration": 350 },
        "modules":{ "left": ["terminal", "workspaces"],
                    "center": ["launcher", "clock", "swaync"],
                    "right": ["updates", "battery", "powerprofile", "volume", "systemtray", "logo", "power"] },
        "border": { "width": 2, "colorTop": "", "colorBottom": "" },
        "opacity":{ "collapsed": 0.6, "expanded": 0.8 },
        "clock":  { "format": "HH:mm" },
        "workspaces": { "count": 5 }
    })

    property var settings: defaultSettings

    // True while the user override file is present. Decides which file is the
    // master for both reads (applySettings) and writes (setEnabled /
    // setAlwaysExpanded).
    property bool overrideExists: false

    // User override / master file. When it loads it becomes the source of truth;
    // when it is absent (loadFailed) the shipped file takes over. printErrors is
    // off so a missing override does not log an error on every startup/reload.
    FileView {
        id: overrideFile
        path: Quickshell.env("HOME") + "/.config/ml4w-statusbar/statusbar.json"
        blockLoading: true
        printErrors: false
        onLoaded: { root.overrideExists = true; root.applySettings() }
        onLoadFailed: { root.overrideExists = false; root.applySettings() }
    }

    // Shipped fallback holding the dynamic state (enabled / alwaysExpanded), used
    // only when the override file is absent. Changes are not picked up
    // automatically; trigger a re-read explicitly with
    //   qs ipc call statusbar reload
    FileView {
        id: settingsFile
        path: Quickshell.env("HOME") + "/.config/ml4w/settings/statusbar.json"
        blockLoading: true
        onLoaded: root.applySettings()
    }

    // The active master file: the override when it exists, otherwise the shipped
    // file. The Sidebar switches write here and applySettings reads from here.
    function masterFile() {
        return root.overrideExists ? overrideFile : settingsFile
    }

    // Force a re-read of both settings files and re-apply them. reload()
    // refreshes each FileView from disk (re-firing onLoaded/onLoadFailed, which
    // re-runs applySettings with an up-to-date overrideExists).
    function reloadSettings(): void {
        overrideFile.reload()
        settingsFile.reload()
        applySettings()
    }

    // Merge one JSON document (given as text) over an already-built settings
    // object, key by key. The leading /* ... */ comment block is stripped so the
    // body stays valid for JSON.parse; empty or unparseable text is ignored so a
    // missing/partial file never clears previously merged values.
    function mergeSettings(merged, src): void {
        if (!src)
            return
        try {
            let raw = src.replace(/\/\*[\s\S]*?\*\//g, "")
            if (raw.trim() === "")
                return
            let parsed = JSON.parse(raw)
            for (let group in parsed)
                for (let key in parsed[group])
                    if (merged[group] !== undefined)
                        merged[group][key] = parsed[group][key]
        } catch (e) {
            console.warn("statusbar settings: could not parse a file,"
                + " ignoring it:", e)
        }
    }

    // Rebuild the settings object: the built-in defaults with the master file
    // merged on top. An explicit masterText can be passed (e.g. right after a
    // switch writes the master file) so the merge does not depend on the FileView
    // buffer having refreshed yet.
    function applySettings(masterText): void {
        let merged = JSON.parse(JSON.stringify(root.defaultSettings))
        let text = (masterText !== undefined) ? masterText : root.masterFile().text()
        mergeSettings(merged, text)
        root.settings = merged
    }

    // Persist a bar.<key> boolean into the master file and return the updated
    // text. A regex replace is used when the key is already present (so the
    // file's formatting/comments are kept); when the key is missing (e.g. an
    // override file that did not list it) it falls back to a JSON rewrite.
    function persistBarFlag(key, on): string {
        let file = root.masterFile()
        let src = file.text()
        let re = new RegExp('("' + key + '"\\s*:\\s*)(true|false)')
        let updated
        if (re.test(src)) {
            updated = src.replace(re, "$1" + (on ? "true" : "false"))
        } else {
            let obj
            try {
                obj = JSON.parse(src.replace(/\/\*[\s\S]*?\*\//g, ""))
            } catch (e) {
                obj = {}
            }
            if (typeof obj !== "object" || obj === null)
                obj = {}
            if (obj.bar === undefined)
                obj.bar = {}
            obj.bar[key] = on
            updated = JSON.stringify(obj, null, 4) + "\n"
        }
        file.setText(updated)
        return updated
    }

    property int barHeight: settings.bar.height
    // Constant vertical space reserved for the bar (windows tile below this).
    property int reservedHeight: settings.bar.reservedHeight

    // Whether the bar is shown. The "enabled" flag in statusbar.json is the
    // single source of truth; it is toggled from the SidebarApp switch and via
    // "qs ipc call statusbar toggle", persisted back to the file, and survives
    // restarts. Kept as a binding so a settings reload updates it for free.
    property bool barEnabled: settings.bar.enabled

    // Hide completely and reserve no space when disabled.
    visible: barEnabled
    // Reserve 20px less than the band so the gap below the pill is smaller
    // than above (windows tile 20px higher).
    exclusiveZone: barEnabled ? reservedHeight - 20 : 0

    // Persist the enabled state into the master file (override when present,
    // otherwise the shipped file) and apply it. applySettings re-parses the
    // updated text, which updates settings.bar.enabled and therefore the
    // barEnabled binding above.
    function setEnabled(on: bool): void {
        applySettings(persistBarFlag("enabled", on))
    }

    // Keep the pill expanded regardless of hover. Set via IPC
    // ("qs ipc call statusbar focus") which is bound to SUPER + SPACE in
    // Hyprland, and cleared on Escape, after running a module, or when the
    // focus grab is released because the user interacted with another window.
    property bool barExpanded: false

    // When set in statusbar.json the pill never collapses: it stays in its
    // expanded (full-width) state independent of hover or the IPC toggle. This
    // is purely visual — unlike barExpanded it does not grab the keyboard — so
    // the left/right module areas remain permanently visible.
    property bool alwaysExpanded: settings.bar.alwaysExpanded

    // Persist the alwaysExpanded state into the master file and apply it.
    // Mirrors setEnabled.
    function setAlwaysExpanded(on: bool): void {
        applySettings(persistBarFlag("alwaysExpanded", on))
    }

    // --- MODULE PLACEMENT ---
    // Each module name in the settings file maps to the component placed into
    // the left/center/right groups. Unknown names load nothing.
    Component { id: cTerminal;   TerminalModule {} }
    Component {
        id: cWorkspaces
        WorkspacesModule {
            minWorkspaces: root.settings.workspaces.count
        }
    }
    Component { id: cLauncher;   LauncherModule {} }
    Component {
        id: cClock
        ClockModule {
            expanded: pill.expanded
            timeFormat: root.settings.clock.format
        }
    }
    Component { id: cSwaync;     SwayncModule {} }
    // True while a system-tray context menu is open. Kept at window scope so
    // the pill can pin itself expanded while a menu is up (the tray lives in
    // the right area, which only exists while expanded).
    property bool trayMenuOpen: false
    Component {
        id: cSystemTray
        SystemTrayModule {
            // Rebuild keyboard navigation when the tray empties or repopulates
            // (it collapses out of the layout when it has no items).
            onCollapsedChanged: Qt.callLater(root.rebuildNavItems)
            // Surface the open-menu state up to the window so the pill stays
            // expanded for as long as a tray menu is showing.
            Binding {
                target: root
                property: "trayMenuOpen"
                value: menuOpen
            }
        }
    }
    Component { id: cLogo;       Ml4wLogoModule {} }
    Component { id: cPower;      PowerModule {} }
    Component { id: cVolume;     VolumeModule {} }
    Component {
        id: cUpdates
        UpdatesModule {
            // Rebuild the keyboard navigation list when the module hides or
            // reappears (its collapsed state tracks the available update count).
            onCollapsedChanged: Qt.callLater(root.rebuildNavItems)
        }
    }
    Component {
        id: cBattery
        BatteryModule {
            // Rebuild the keyboard navigation list when the module hides or
            // reappears (it only shows while running on battery power).
            onCollapsedChanged: Qt.callLater(root.rebuildNavItems)
        }
    }
    Component { id: cPowerProfile; PowerProfileModule {} }

    readonly property var moduleComponents: ({
        "terminal":   cTerminal,
        "workspaces": cWorkspaces,
        "launcher":   cLauncher,
        "clock":      cClock,
        "swaync":     cSwaync,
        "systemtray": cSystemTray,
        "logo":       cLogo,
        "power":      cPower,
        "updates":      cUpdates,
        "volume":       cVolume,
        "battery":      cBattery,
        "powerprofile": cPowerProfile
    })

    // --- KEYBOARD NAVIGATION ---
    // Ordered left-to-right list of the navigable items, rebuilt from the
    // placed modules whenever the layout or the (dynamic) workspace buttons
    // change. The workspace buttons are spliced in at the workspaces module's
    // position; collection modules without a single action (the system tray)
    // are skipped.
    property var navItems: []
    // Index of the keyboard-selected item, or -1 when none is selected.
    property int focusIndex: -1

    // The placed workspaces module, tracked so navItems can be rebuilt when its
    // button list changes (workspaces appear/disappear asynchronously).
    property var workspacesRef: null
    Connections {
        target: root.workspacesRef
        ignoreUnknownSignals: true
        function onNavButtonsChanged(): void { root.rebuildNavItems() }
    }

    function rebuildNavItems(): void {
        let items = []
        let ws = null
        let groups = [leftRepeater, centerRepeater, rightRepeater]
        for (let g = 0; g < groups.length; g++) {
            let rep = groups[g]
            for (let i = 0; i < rep.count; i++) {
                let loader = rep.itemAt(i)
                let m = loader ? loader.item : null
                if (!m)
                    continue
                if (m.collapsed === true)                // hidden (e.g. updates)
                    continue
                if (m.navButtons !== undefined) {        // workspaces
                    ws = m
                    items = items.concat(m.navButtons)
                } else if (typeof m.activate === "function") {
                    items.push(m)
                }
            }
        }
        root.workspacesRef = ws
        root.navItems = items
    }

    Component.onCompleted: Qt.callLater(rebuildNavItems)
    onSettingsChanged: Qt.callLater(rebuildNavItems)

    // Highlight exactly the item at focusIndex and clear all others. Called
    // both when the selection moves and when navItems changes underneath it.
    function applyFocus(): void {
        let items = root.navItems
        for (let i = 0; i < items.length; i++)
            items[i].focused = (i === root.focusIndex)
    }

    onFocusIndexChanged: applyFocus()
    onNavItemsChanged: {
        // Keep the selection in range when the workspace count changes.
        if (root.focusIndex >= root.navItems.length)
            root.focusIndex = root.navItems.length - 1
        applyFocus()
    }

    onBarExpandedChanged: {
        if (barExpanded) {
            focusIndex = 0
            keyHandler.forceActiveFocus()
        } else {
            focusIndex = -1
        }
    }

    function moveFocus(dir: int): void {
        if (!barExpanded)
            return
        let n = root.navItems.length
        root.focusIndex = (root.focusIndex + dir + n) % n
    }

    // Forward an Up/Down press to the keyboard-selected module if it exposes a
    // step() function (e.g. the volume module), so the arrows adjust it in place
    // without leaving keyboard-navigation mode.
    function stepFocused(dir: int): void {
        if (root.focusIndex < 0 || root.focusIndex >= root.navItems.length)
            return
        let m = root.navItems[root.focusIndex]
        if (typeof m.step === "function")
            m.step(dir)
    }

    function activateFocused(): void {
        if (root.focusIndex >= 0 && root.focusIndex < root.navItems.length)
            root.navItems[root.focusIndex].activate()
        // Collapse so the keyboard is handed back to the (possibly newly
        // launched) application instead of staying captured by the bar.
        root.barExpanded = false
    }

    IpcHandler {
        target: "statusbar"
        function toggle(): void { root.setEnabled(!root.settings.bar.enabled) }
        // Named enable/disable rather than show/hide: "show" is a reserved
        // subcommand of "qs ipc" and would never reach the function.
        function enable(): void { root.setEnabled(true) }
        function disable(): void { root.setEnabled(false) }
        // Persist and apply the alwaysExpanded (permanently expanded) mode,
        // toggled from the SidebarApp switch.
        function alwaysExpand(): void { root.setAlwaysExpanded(true) }
        function autoCollapse(): void { root.setAlwaysExpanded(false) }
        // Re-read statusbar.json from disk (used by the SidebarApp switch).
        function refresh(): void { root.reloadSettings() }
        // Expand the bar (if needed) and grab the keyboard for navigation.
        // Bound to SUPER + SPACE. Idempotent: when the bar is already expanded
        // it only re-grabs keyboard focus instead of toggling back to collapsed,
        // so the keybinding always lands in keyboard-navigation mode.
        function focus(): void {
            root.barExpanded = true
            keyHandler.forceActiveFocus()
        }
        // Toggle between collapsed and expanded mode.
        function expand(): void { root.barExpanded = !root.barExpanded }
        function collapse(): void { root.barExpanded = false }
        // Re-read statusbar.json and apply the changes.
        function reload(): void { root.reloadSettings() }
    }

    color: "transparent"

    // Full-width strip anchored to the top of the screen
    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 0
    }

    implicitHeight: barHeight + 40

    // ==========================================
    // CENTERED PILL
    // ==========================================
    Item {
        id: pill
        anchors.horizontalCenter: parent.horizontalCenter
        // Center the pill within the reserved band. The window is taller than
        // the band (to fit the shadow / expanded pill), so offset accordingly.
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: (root.reservedHeight / 2) - (root.implicitHeight / 2)

        // Collapsed = sized to content, Expanded = fixed width.
        property bool expanded: hoverHandler.hovered || root.barExpanded
            || root.alwaysExpanded || root.trayMenuOpen
        // 0 in the settings file means "hug the center content".
        property real collapsedWidth: root.settings.pill.collapsedWidth > 0
            ? root.settings.pill.collapsedWidth
            : centerArea.implicitWidth + 32

        // Minimum width the content needs so the centered center area never
        // overlaps the left/right areas. The center stays centered, so each
        // side must clear half of it: the bar has to be at least as wide as the
        // center plus twice the wider of the two side areas (whichever side
        // would collide first), plus the 16px edge margins and some breathing
        // room. Computed live so adding workspaces (or any module growing)
        // pushes the bar wider instead of clipping.
        property real contentWidth: centerArea.implicitWidth
            + 2 * Math.max(leftArea.implicitWidth, rightArea.implicitWidth)
            + 64
        // expandedWidth from the settings file is treated as a minimum: the
        // pill grows past it when the content needs more room.
        property real expandedWidth: Math.max(
            root.settings.pill.expandedWidth, contentWidth)

        width: expanded ? expandedWidth : collapsedWidth
        height: expanded ? root.barHeight + 10 : root.barHeight

        Behavior on width {
            NumberAnimation {
                duration: root.settings.pill.animationDuration
                easing.type: Easing.OutQuint
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: root.settings.pill.animationDuration
                easing.type: Easing.OutQuint
            }
        }

        HoverHandler {
            id: hoverHandler
        }

        // Captures arrow keys (navigate), Return (execute) and Escape
        // (collapse) while the bar is in expanded mode.
        FocusScope {
            id: keyHandler
            anchors.fill: parent
            focus: root.barExpanded
            Keys.onLeftPressed: root.moveFocus(-1)
            Keys.onRightPressed: root.moveFocus(1)
            Keys.onUpPressed: root.stepFocused(1)
            Keys.onDownPressed: root.stepFocused(-1)
            Keys.onReturnPressed: root.activateFocused()
            Keys.onEnterPressed: root.activateFocused()
            Keys.onEscapePressed: root.barExpanded = false
        }

        RectangularShadow {
            anchors.fill: pillBg
            radius: pillBg.radius
            blur: 15
            color: Qt.rgba(Theme.shadow.r, Theme.shadow.g, Theme.shadow.b, 0.4)
        }

        // Gradient BORDER layer (outer)
        Rectangle {
            id: pillBg
            anchors.fill: parent
            radius: root.settings.pill.radius
            opacity: pill.expanded
                ? root.settings.opacity.expanded
                : root.settings.opacity.collapsed
            Behavior on opacity {
                NumberAnimation {
                    duration: root.settings.pill.animationDuration
                    easing.type: Easing.OutQuint
                }
            }

            // Border colors come from the settings file; empty strings fall
            // back to the dynamic wallpaper theme.
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop {
                    position: 0.0
                    color: root.settings.border.colorTop !== ""
                        ? root.settings.border.colorTop
                        : Theme.primary
                }
                GradientStop {
                    position: 1.0
                    color: root.settings.border.colorBottom !== ""
                        ? root.settings.border.colorBottom
                        : Theme.on_primary
                }
            }

            // Actual background fill (inner), inset by the border thickness
            Rectangle {
                anchors.fill: parent
                anchors.margins: root.settings.border.width
                radius: parent.radius - anchors.margins
                color: Theme.background
            }
        }

        // ==========================================
        // LEFT AREA (only visible when expanded)
        // ==========================================
        RowLayout {
            id: leftArea
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14

            opacity: pill.expanded ? 1 : 0
            visible: opacity > 0
            enabled: pill.expanded

            Behavior on opacity {
                NumberAnimation { duration: 250; easing.type: Easing.OutQuint }
            }

            Repeater {
                id: leftRepeater
                model: root.settings.modules.left
                Loader {
                    Layout.alignment: Qt.AlignVCenter
                    sourceComponent: root.moduleComponents[modelData] || null
                    onLoaded: Qt.callLater(root.rebuildNavItems)
                }
            }
        }

        // ==========================================
        // CENTER AREA (always visible)
        // ==========================================
        RowLayout {
            id: centerArea
            anchors.centerIn: parent
            spacing: 14

            Repeater {
                id: centerRepeater
                model: root.settings.modules.center
                Loader {
                    Layout.alignment: Qt.AlignVCenter
                    sourceComponent: root.moduleComponents[modelData] || null
                    onLoaded: Qt.callLater(root.rebuildNavItems)
                }
            }
        }

        // ==========================================
        // RIGHT AREA (only visible when expanded)
        // ==========================================
        RowLayout {
            id: rightArea
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14

            opacity: pill.expanded ? 1 : 0
            visible: opacity > 0
            enabled: pill.expanded

            Behavior on opacity {
                NumberAnimation { duration: 250; easing.type: Easing.OutQuint }
            }

            Repeater {
                id: rightRepeater
                model: root.settings.modules.right
                Loader {
                    Layout.alignment: Qt.AlignVCenter
                    sourceComponent: root.moduleComponents[modelData] || null
                    // Collapse the layout slot when the module marks itself
                    // collapsed (e.g. the updates module with no pending
                    // updates). Reading the plain `collapsed` flag — rather than
                    // the module's effective `visible` — avoids a binding latch
                    // that would pin this Loader hidden once the right area
                    // collapses in the pill's collapsed state.
                    visible: (item && item.collapsed !== undefined) ? !item.collapsed : true
                    onLoaded: Qt.callLater(root.rebuildNavItems)
                }
            }
        }
    }
}
