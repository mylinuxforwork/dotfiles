pragma Singleton
import QtQuick
import Quickshell 
import Quickshell.Io 

QtObject { 
    id: root
    
    // Static properties
    readonly property string fontFamily: "Fira Sans Semibold"
    
    // Dynamic color properties
    property color background: "#1a1110"
    property color error: "#ffb4ab"
    property color error_container: "#93000a"
    property color inverse_on_surface: "#392e2c"
    property color inverse_primary: "#904b3d"
    property color inverse_surface: "#f1dfdb"
    property color on_background: "#f1dfdb"
    property color on_error: "#690005"
    property color on_error_container: "#ffdad6"
    property color on_primary: "#561f13"
    property color on_primary_container: "#ffdad3"
    property color on_primary_fixed: "#3a0a03"
    property color on_primary_fixed_variant: "#733427"
    property color on_secondary: "#442a24"
    property color on_secondary_container: "#ffdad3"
    property color on_secondary_fixed: "#2c1510"
    property color on_secondary_fixed_variant: "#5d3f39"
    property color on_surface: "#f1dfdb"
    property color on_surface_variant: "#d8c2bd"
    property color on_tertiary: "#3d2f04"
    property color on_tertiary_container: "#f9e0a6"
    property color on_tertiary_fixed: "#241a00"
    property color on_tertiary_fixed_variant: "#554519"
    property color outline: "#a08c88"
    property color outline_variant: "#534340"
    property color primary: "#ffb4a5"
    property color primary_container: "#733427"
    property color primary_fixed: "#ffdad3"
    property color primary_fixed_dim: "#ffb4a5"
    property color scrim: "#000000"
    property color secondary: "#e7bdb4"
    property color secondary_container: "#5d3f39"
    property color secondary_fixed: "#ffdad3"
    property color secondary_fixed_dim: "#e7bdb4"
    property color shadow: "#000000"
    property color source_color: "#fc2f04"
    property color surface: "#1a1110"
    property color surface_bright: "#423734"
    property color surface_container: "#271d1b"
    property color surface_container_high: "#322826"
    property color surface_container_highest: "#3d3230"
    property color surface_container_low: "#231917"
    property color surface_container_lowest: "#140c0a"
    property color surface_dim: "#1a1110"
    property color surface_tint: "#ffb4a5"
    property color surface_variant: "#534340"
    property color tertiary: "#dcc48c"
    property color tertiary_container: "#554519"
    property color tertiary_fixed: "#f9e0a6"
    property color tertiary_fixed_dim: "#dcc48c"

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

    function reloadTheme() {
        // Toggle false then true to guarantee Quickshell restarts the cat process
        reader.running = false;
        reader.running = true;
    }

    // Load the JSON colors automatically when Quickshell starts
    // Component.onCompleted: reloadTheme()
}