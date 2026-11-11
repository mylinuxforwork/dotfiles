pragma Singleton
import QtQuick
import Quickshell 
import Quickshell.Io 

QtObject { 
    id: root
    
    // Static properties
    readonly property string fontFamily: "Fira Sans Semibold"
    
    // True while the loaded palette is a light one. Derived from the palette
    // itself rather than read from the GTK preference, so it updates atomically
    // with reloadTheme() and stays correct for any hand-written colors.json.
    readonly property bool isLight: background.hslLightness > 0.5

    // Dynamic color properties
    property color background: "#0e1514"
    property color error: "#ffb4ab"
    property color error_container: "#93000a"
    property color inverse_on_surface: "#2b3231"
    property color inverse_primary: "#006a64"
    property color inverse_surface: "#dde4e2"
    property color on_background: "#dde4e2"
    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"
    property color on_primary: "#003734"
    property color on_primary_container: "#9df2e9"
    property color on_primary_fixed: "#00201e"
    property color on_primary_fixed_variant: "#00504b"
    property color on_secondary: "#1c3532"
    property color on_secondary_container: "#cce8e4"
    property color on_secondary_fixed: "#051f1d"
    property color on_secondary_fixed_variant: "#324b49"
    property color on_surface: "#dde4e2"
    property color on_surface_variant: "#bec9c6"
    property color on_tertiary: "#18324a"
    property color on_tertiary_container: "#cfe5ff"
    property color on_tertiary_fixed: "#001d33"
    property color on_tertiary_fixed_variant: "#304962"
    property color outline: "#899391"
    property color outline_variant: "#3f4947"
    property color primary: "#81d5cd"
    property color primary_container: "#00504b"
    property color primary_fixed: "#9df2e9"
    property color primary_fixed_dim: "#81d5cd"
    property color scrim: "#000000"
    property color secondary: "#b0ccc8"
    property color secondary_container: "#324b49"
    property color secondary_fixed: "#cce8e4"
    property color secondary_fixed_dim: "#b0ccc8"
    property color shadow: "#000000"
    property color source_color: "#458680"
    property color surface: "#0e1514"
    property color surface_bright: "#343a39"
    property color surface_container: "#1a2120"
    property color surface_container_high: "#252b2a"
    property color surface_container_highest: "#303635"
    property color surface_container_low: "#161d1c"
    property color surface_container_lowest: "#090f0f"
    property color surface_dim: "#0e1514"
    property color surface_tint: "#81d5cd"
    property color surface_variant: "#3f4947"
    property color tertiary: "#afc9e7"
    property color tertiary_container: "#304962"
    property color tertiary_fixed: "#cfe5ff"
    property color tertiary_fixed_dim: "#afc9e7"

    property var themeReader: Process {
        id: reader
        command: ["cat", Quickshell.env("HOME") + "/.config/ml4w/colors/colors.json"]
        
        // REQUIRED: Quickshell needs this to parse the binary stream into text
        stdout: StdioCollector {
            onStreamFinished: {
                // "this.text" contains the full output of the cat command
                var output = this.text.trim();
                
                if (output !== "") {
                    try {
                        var newColors = JSON.parse(output);
                        for (var key in newColors) {
                            if (root.hasOwnProperty(key) && key !== "objectName") {
                                root[key] = newColors[key];
                            }
                        }
                        console.log("Theme colors loaded successfully!");
                    } catch (e) {
                        console.log("Failed to parse theme JSON: " + e);
                    }
                }
            }
        }
    }

    // --- GLOBAL BACKGROUND OPACITY ---
    // Background opacity of the Quickshell surfaces (statusbar, ...), set from
    // the Opacity slider in the sidebar's Appearance section. Stored as a
    // percentage (0-100) in a plain file so other Quickshell configs (dock,
    // power menu) can read and watch the same value:
    //
    //   ~/.config/ml4w/settings/quickshell-opacity
    //
    // -1 while the file is missing or invalid: each surface then keeps its own
    // default opacity.
    property int backgroundOpacity: -1

    // Opacity (0-1) for a surface's background: the global value when it is
    // set, otherwise the surface's own default.
    function surfaceOpacity(fallback) {
        return root.backgroundOpacity >= 0 ? root.backgroundOpacity / 100 : fallback;
    }

    // Persist a percentage. backgroundOpacity is assigned directly so the
    // change is visible at once; the file watcher re-reads the same value.
    // Other configs watching the file (the dock) follow it on their own, even
    // when this save creates the file.
    function saveBackgroundOpacity(percent) {
        let p = Math.max(0, Math.min(100, Math.round(percent)));
        root.backgroundOpacity = p;
        opacityFile.setText(p + "\n");
    }

    property var opacityFile: FileView {
        id: opacityFile
        path: Quickshell.env("HOME") + "/.config/ml4w/settings/quickshell-opacity"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            let v = parseInt(text().trim());
            root.backgroundOpacity = isNaN(v) ? -1 : Math.max(0, Math.min(100, v));
        }
        onLoadFailed: root.backgroundOpacity = -1
    }

    // --- BLUR ---
    // Whether Hyprland blurs behind the Quickshell surfaces, mirrored from
    //
    //   ~/.config/ml4w/settings/quickshell-blur
    //
    // ("on"/"off", missing = on), which ml4w-quickshell-blur writes and
    // hypr/conf/ml4w.lua reads. The blur rule uses ignore_alpha, so it also
    // blurs the denser part of a drop shadow and ends in a hard edge around the
    // panel. Surfaces therefore hide their shadow while blur is on.
    property bool blurEnabled: true

    property var blurFile: FileView {
        id: blurFile
        path: Quickshell.env("HOME") + "/.config/ml4w/settings/quickshell-blur"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: root.blurEnabled = text().trim() !== "off"
        onLoadFailed: root.blurEnabled = true
    }

    // --- TRANSPARENT BORDER ---
    // Whether the border of the Quickshell surfaces follows the background
    // opacity (on, the default) or stays at fixedBorderOpacity (off). Set from
    // the Transparent Border switch in the sidebar and stored as "on"/"off" in
    //
    //   ~/.config/ml4w/settings/quickshell-transparent-border
    //
    // which the dock and power menu watch as well. Missing = on.
    property bool transparentBorder: true
    readonly property real fixedBorderOpacity: 0.8

    // Opacity (0-1) for a surface's border, given its background opacity.
    function borderOpacity(fillOpacity) {
        return root.transparentBorder ? fillOpacity : root.fixedBorderOpacity;
    }

    function saveTransparentBorder(on) {
        root.transparentBorder = on;
        transparentBorderFile.setText((on ? "on" : "off") + "\n");
    }

    property var transparentBorderFile: FileView {
        id: transparentBorderFile
        path: Quickshell.env("HOME") + "/.config/ml4w/settings/quickshell-transparent-border"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: root.transparentBorder = text().trim() !== "off"
        onLoadFailed: root.transparentBorder = true
    }

    function reloadTheme() {
        // Toggle false then true to guarantee Quickshell restarts the cat process
        reader.running = false;
        reader.running = true;
    }

    // Load the JSON colors automatically when Quickshell starts
    // Component.onCompleted: reloadTheme()
}