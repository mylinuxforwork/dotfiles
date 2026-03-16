import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.shared

PanelWindow {
    id: root
    
    // --- WAYLAND CONFIGURATION ---
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: WlrExclusionMode.Ignore 
    
    width: 380
    height: 750 
    color: "transparent"

    anchors {
        right: true
    }

    // --- ANIMATION LOGIC ---
    property bool isOpen: false
    visible: isOpen || slideAnim.running
    
    margins { right: root.currentMargin }
    property real currentMargin: isOpen ? 20 : -450 

    Behavior on currentMargin {
        NumberAnimation {
            id: slideAnim
            duration: 350
            easing.type: Easing.OutQuint 
        }
    }

    IpcHandler {
        target: "sidebar"
        function toggle(): void {
            root.isOpen = !root.isOpen
            if (root.isOpen) {
                statusChecker.running = true 
            }
        }
    }

    Theme { id: theme }

    // --- PROCESS RUNNERS ---
    Process {
        id: appLauncher
        running: false
    }

    Process {
        id: statusChecker
        running: false
        command: ["bash", "-c", `
            echo "gamemode:$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')"
            echo "waybar:$(pgrep -x waybar > /dev/null && echo 1 || echo 0)"
            echo "sidepad:$(pgrep -f "nwg-panel -c sidepad" > /dev/null && echo 1 || echo 0)"
            echo "dock:$(pgrep -x nwg-dock-hyprla > /dev/null && echo 1 || echo 0)"
        `]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n")
                lines.forEach(line => {
                    let parts = line.split(":")
                    if (parts.length === 2) {
                        let key = parts[0]
                        let val = parts[1]
                        if (key === "gamemode") gamemodeSwitch.checked = (val === "0")
                        if (key === "waybar") waybarSwitch.checked = (val === "1")
                        if (key === "sidepad") sidepadSwitch.checked = (val === "1")
                        if (key === "dock") dockSwitch.checked = (val === "1")
                    }
                })
            }
        }
    }

    // --- REUSABLE COMPONENTS ---
    component ML4WMenuItem: MenuItem {
        id: control
        contentItem: Text {
            text: control.text
            font.family: theme.fontFamily
            font.pixelSize: 14
            color: control.highlighted ? theme.background : theme.primary 
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 36
            color: control.highlighted ? theme.primary : "transparent"
            radius: 4
        }
    }

    component ML4WButton: Button {
        Layout.fillWidth: true
        background: Rectangle {
            color: "transparent"
            border.color: theme.primary
            border.width: 1
            radius: 10
        }
        contentItem: Text {
            text: parent.text
            font.family: theme.fontFamily
            font.pixelSize: 13
            color: theme.primary
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            padding: 8
        }
    }

    component ML4WSwitch: Switch {
        Layout.alignment: Qt.AlignVCenter
        implicitWidth: 48
        implicitHeight: 26
        indicator: Rectangle {
            implicitWidth: 48
            implicitHeight: 26
            radius: 13
            color: parent.checked ? theme.primary : theme.background
            border.color: theme.primary
            border.width: 1
            Rectangle {
                x: parent.parent.checked ? parent.width - width - 2 : 2
                y: 2
                width: 22
                height: 22
                radius: 11
                color: parent.parent.checked ? theme.background : theme.on_primary
                Behavior on x { NumberAnimation { duration: 150 } }
            }
        }
    }

    component SettingsWheel: Button {
        implicitWidth: 28  
        implicitHeight: 28
        text: "" 
        font.family: "monospace"
        background: Rectangle { color: "transparent" }
        contentItem: Text { 
            text: parent.text; color: theme.primary; font.pixelSize: 18; 
            verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
        }
    }

    component ActionIcon: Button {
        property string iconTxt: ""
        implicitWidth: 28  
        implicitHeight: 28
        text: iconTxt
        font.family: "monospace"
        background: Rectangle { color: "transparent" }
        contentItem: Text { 
            text: parent.text; color: theme.primary; font.pixelSize: 18; 
            verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
        }
    }

    // ==========================================
    // MAIN PANEL BACKGROUND
    // ==========================================
    Rectangle {
        anchors.fill: parent
        color: theme ? theme.background : "#1e1e2e"
        border.color: theme ? theme.primary : "#89b4fa"
        border.width: 2
        radius: 20

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            // --- 1. TOP BAR (Light/Dark & Color Picker only) ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                ActionIcon {
                    iconTxt: "󰔎"
                    onClicked: {
                        appLauncher.running = false
                        appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/toggleall.sh &"]
                        appLauncher.running = true
                    }
                }

                ActionIcon {
                    iconTxt: "" 
                    onClicked: {
                        root.isOpen = false
                        appLauncher.running = false
                        appLauncher.command = ["bash", "-c", "hyprpicker -a &"]
                        appLauncher.running = true
                    }
                }

                Item { Layout.fillWidth: true } 
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: theme.primary; opacity: 0.3 }

            // --- 3. THREE BUTTONS ROW ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                ML4WButton { 
                    text: "Welcome"
                    onClicked: {
                        appLauncher.running = false
                        appLauncher.command = ["bash", "-c", "qs ipc call welcome toggle &"]
                        appLauncher.running = true
                    }
                }
                ML4WButton { 
                    text: "Settings"
                    onClicked: {
                        appLauncher.running = false
                        // Kept as a single string so Bash interprets the full command correctly!
                        appLauncher.command = ["bash", "-c", "qs -p " + Quickshell.env("HOME") + "/.local/share/ml4w-dotfiles-settings/quickshell ipc call settings toggle &"]
                        appLauncher.running = true
                    }
                }
                ML4WButton { 
                    text: "Hyprland"
                    onClicked: {
                        appLauncher.running = false
                        appLauncher.command = ["bash", "-c", "flatpak run com.ml4w.hyprlandsettings &"]
                        appLauncher.running = true
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; height: 1; color: theme.primary; opacity: 0.3 }

            // --- SCROLLABLE CONTENT ---
            ScrollView {
                id: scrollView 
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: availableWidth 
                clip: true

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    interactive: true
                    contentItem: Rectangle {
                        implicitWidth: 6; radius: 3; color: theme.primary
                        opacity: parent.pressed ? 1.0 : (parent.active ? 0.8 : 0.4)
                    }
                }

                ColumnLayout {
                    width: scrollView.availableWidth - 16
                    spacing: 20

                    // --- 4. WAYBAR ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Waybar"; color: theme.on_background; font.family: theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true } 
                        ML4WSwitch { 
                            id: waybarSwitch
                            onClicked: {
                                appLauncher.running = false
                                appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/waybar.sh &"]
                                appLauncher.running = true
                            }
                        }
                        SettingsWheel {
                            onClicked: waybarMenu.open()
                            Menu {
                                id: waybarMenu
                                y: parent.height
                                
                                // FIX: Added width and padding so the menu doesn't collapse
                                width: 220
                                padding: 8
                                
                                background: Rectangle { color: theme.background; border.color: theme.primary; border.width: 1; radius: 8 }
                                ML4WMenuItem { text: "Select Waybar Theme"; onClicked: console.log("TODO") }
                                ML4WMenuItem { text: "Edit Quicklinks"; onClicked: console.log("TODO") }
                                ML4WMenuItem { text: "Reload Waybar"; onClicked: console.log("TODO") }
                            }
                        }
                    }

                    // --- 5. DOCK ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Dock"; color: theme.on_background; font.family: theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true }
                        ML4WSwitch { 
                            id: dockSwitch
                            onClicked: {
                                appLauncher.running = false
                                appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/nwg-dock.sh &"]
                                appLauncher.running = true
                            }
                        }
                        Item { width: 28 } 
                    }

                    // --- 6. GAMEMODE ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Gamemode"; color: theme.on_background; font.family: theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true }
                        ML4WSwitch { 
                            id: gamemodeSwitch
                            onClicked: {
                                appLauncher.running = false
                                appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/gamemode.sh &"]
                                appLauncher.running = true
                            }
                        }
                        Item { width: 28 } 
                    }

                    // --- 7. SIDEPAD ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Sidepad"; color: theme.on_background; font.family: theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true }
                        ML4WSwitch { 
                            id: sidepadSwitch
                            onClicked: {
                                appLauncher.running = false
                                appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/sidepad.sh &"]
                                appLauncher.running = true
                            }
                        }
                        SettingsWheel {
                            onClicked: sidepadMenu.open()
                            Menu {
                                id: sidepadMenu
                                y: parent.height
                                
                                width: 220
                                padding: 8
                                
                                background: Rectangle { color: theme.background; border.color: theme.primary; border.width: 1; radius: 8 }
                                ML4WMenuItem { text: "Select Sidepad"; onClicked: console.log("TODO") }
                                ML4WMenuItem { text: "Open Sidepad Folder"; onClicked: console.log("TODO") }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; height: 1; color: theme.primary; opacity: 0.3; Layout.topMargin: 5; Layout.bottomMargin: 5 }

                    // --- 8. WALLPAPER ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Wallpaper"; color: theme.on_background; font.family: theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true }
                        ActionIcon { 
                            iconTxt: ""
                            onClicked: {
                                root.isOpen = false
                                appLauncher.running = false
                                appLauncher.command = ["bash", "-c", "waypaper &"]
                                appLauncher.running = true
                            }
                        }
                        SettingsWheel {
                            onClicked: wallpaperMenu.open()
                            Menu {
                                id: wallpaperMenu
                                y: parent.height
                                
                                width: 220
                                padding: 8
                                
                                background: Rectangle { color: theme.background; border.color: theme.primary; border.width: 1; radius: 8 }
                                ML4WMenuItem { text: "Random Wallpaper"; onClicked: console.log("TODO") }
                                ML4WMenuItem { text: "Wallpaper Effects"; onClicked: console.log("TODO") }
                            }
                        }
                    }

                    // --- 9. THEME ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Theme"; color: theme.on_background; font.family: theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true }
                        ActionIcon { 
                            iconTxt: ""
                            onClicked: {
                                root.isOpen = false
                                appLauncher.running = false
                                appLauncher.command = ["bash", "-c", "rofi -show drun &"]
                                appLauncher.running = true
                            }
                        }
                        SettingsWheel {
                            onClicked: themeMenu.open()
                            Menu {
                                id: themeMenu
                                y: parent.height
                                
                                width: 220
                                padding: 8
                                
                                background: Rectangle { color: theme.background; border.color: theme.primary; border.width: 1; radius: 8 }
                                ML4WMenuItem { text: "Set GTK Theme"; onClicked: console.log("TODO") }
                                ML4WMenuItem { text: "Set QT Theme"; onClicked: console.log("TODO") }
                                ML4WMenuItem { text: "Refresh GTK Theme"; onClicked: console.log("TODO") }
                            }
                        }
                    }

                    // --- 10. SCREENSHOT ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Screenshot"; color: theme.on_background; font.family: theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true } 
                        ActionIcon { 
                            iconTxt: ""
                            onClicked: {
                                root.isOpen = false
                                appLauncher.running = false
                                appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/screenshot.sh &"]
                                appLauncher.running = true
                            }
                        }
                        Item { width: 28 } 
                    }
                }
            }
        }
    }
}