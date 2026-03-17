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
    exclusionMode: WlrLayershell.Ignore
    
    implicitWidth: 380
    implicitHeight: 750 
    color: "transparent"

    anchors {
        right: true
        top: true
    }

    margins { 
        top: 87        // Your requested 63px gap from the top of the screen
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
        }
    }

    Theme { id: theme }

    // --- PROCESS RUNNERS ---
    Process {
        id: appLauncher
        running: false
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
                implicitWidth: 22
                implicitHeight: 22
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
        radius: 10

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
                        appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-toggle-theme"]
                        appLauncher.running = true
                    }
                }

                ActionIcon {
                    iconTxt: "" 
                    onClicked: {
                        root.isOpen = false
                        appLauncher.running = false
                        appLauncher.command = ["hyprpicker"]
                        appLauncher.running = true
                    }
                }

                Item { Layout.fillWidth: true } 
            }

            Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: theme.primary; opacity: 0.3 }

            // --- 3. THREE BUTTONS ROW ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                ML4WButton { 
                    text: "Welcome"
                    onClicked: {
                        root.isOpen = false
                        appLauncher.running = false
                        appLauncher.command = ["bash", "-c", "qs ipc call welcome toggle"]
                        appLauncher.running = true
                    }
                }
                ML4WButton { 
                    text: "Settings"
                    onClicked: {
                        root.isOpen = false
                        appLauncher.running = false
                        appLauncher.command = ["bash", "-c", "qs -p " + Quickshell.env("HOME") + "/.local/share/ml4w-dotfiles-settings/quickshell ipc call settings toggle"]
                        appLauncher.running = true
                    }
                }
                ML4WButton { 
                    text: "Hyprland"
                    onClicked: {
                        root.isOpen = false
                        appLauncher.running = false
                        appLauncher.command = ["bash", "-c", "flatpak run com.ml4w.hyprlandsettings"]
                        appLauncher.running = true
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: theme.primary; opacity: 0.3 }

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
                    implicitWidth: scrollView.availableWidth - 16
                    spacing: 20

                    // --- 4. WAYBAR ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Waybar"; color: theme.on_background; font.family: theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true } 
                        ML4WSwitch { 
                            id: waybarSwitch
                            property bool ready: false
                            Process {
                                command: ["bash", "-c", "test -f ~/.config/ml4w/settings/waybar-disabled && echo 0 || echo 1"]
                                running: root.isOpen 
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        console.log("Test for Waybar: " + this.text.trim())
                                        waybarSwitch.checked = (this.text.trim() === "1")
                                        waybarSwitch.ready = true
                                    }
                                }
                            }
                            onClicked: {
                                if (!ready) return;
                                let fileCmd = checked 
                                ? "rm -f ~/.config/ml4w/settings/waybar-disabled"
                                : "touch ~/.config/ml4w/settings/waybar-disabled"       
                                console.log("Waybar cmd: " + fileCmd)
                                appLauncher.running = false
                                appLauncher.command = ["bash", "-c", fileCmd + ";sleep 1;" + Quickshell.env("HOME") + "/.config/waybar/launch.sh"]
                                appLauncher.running = true
                            }
                        }

                        SettingsWheel {
                            onClicked: waybarMenu.open()
                            Menu {
                                id: waybarMenu
                                y: parent.height
                                implicitWidth: 220
                                padding: 8
                                
                                background: Rectangle { color: theme.background; border.color: theme.primary; border.width: 1; radius: 8 }
                                ML4WMenuItem { text: "Select Waybar Theme"; onClicked: {
                                        appLauncher.running = false
                                        appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/waybar/themeswitcher.sh"]
                                        appLauncher.running = true
                                    }
                                
                                }
                                ML4WMenuItem { text: "Edit Quicklinks"; onClicked: {
                                        root.isOpen = false
                                        appLauncher.running = false
                                        appLauncher.command = ["gnome-text-editor", Quickshell.env("HOME") + "/.config/ml4w/settings/waybar-quicklinks.json"]
                                        appLauncher.running = true
                                    }
                                }
                                ML4WMenuItem { text: "Reload Waybar"; onClicked: {
                                        appLauncher.running = false
                                        appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/waybar/launch.sh"]
                                        appLauncher.running = true
                                    } 
                                }
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
                            property bool ready: false
                            Process {
                                command: ["bash", "-c", "test -f ~/.config/ml4w/settings/dock-disabled && echo 0 || echo 1"]
                                running: root.isOpen 
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        console.log("Test for Dock: " + this.text.trim())
                                        dockSwitch.checked = (this.text.trim() === "1")
                                        dockSwitch.ready = true
                                    }
                                }
                            }
                            onClicked: {
                                if (!ready) return;
                                let fileCmd = checked 
                                ? "rm -f ~/.config/ml4w/settings/dock-disabled"
                                : "touch ~/.config/ml4w/settings/dock-disabled"
                                console.log("Dock cmd: " + fileCmd)
                                appLauncher.running = false
                                appLauncher.command = ["bash", "-c", fileCmd + ";sleep 1;" + Quickshell.env("HOME") + "/.config/nwg-dock-hyprland/launch.sh"]
                                appLauncher.running = true
                            }
                        }
                        Item { implicitWidth: 28 } 
                    }

                    // --- 6. GAMEMODE ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Gamemode"; color: theme.on_background; font.family: theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true }
                        ML4WSwitch { 
                            id: gamemodeSwitch
                            property bool ready: false
                            Process {
                                command: ["bash", "-c", "test -f ~/.config/ml4w/settings/gamemode-enabled && echo 1 || echo 0"]
                                running: root.isOpen 
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        console.log("Test for Gamemode: " + this.text.trim())
                                        gamemodeSwitch.checked = (this.text.trim() === "1")
                                        gamemodeSwitch.ready = true
                                    }
                                }
                            }
                            onClicked: {
                                if (!ready) return;
                                let fileCmd = checked 
                                    ? "touch ~/.config/ml4w/settings/gamemode-enabled" 
                                    : "rm -f ~/.config/ml4w/settings/gamemode-enabled"
                                console.log("Test " + fileCmd)
                                appLauncher.running = false
                                appLauncher.command = ["bash", "-c", fileCmd + ";sleep 1;" + Quickshell.env("HOME") + "/.config/hypr/scripts/gamemode.sh"]
                                appLauncher.running = true
                            }
                        }
                        Item { implicitWidth: 28 } 
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
                                if (checked) {
                                    console.log("Launchung sidebar...")
                                    appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-sidepad --init"]
                                } else {
                                    console.log("Stopping sidebar...")
                                    appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-sidepad --kill"]
                                }
                                appLauncher.running = true
                            }
                        }
                        SettingsWheel {
                            onClicked: sidepadMenu.open()
                            Menu {
                                id: sidepadMenu
                                y: parent.height
                                
                                implicitWidth: 220
                                padding: 8
                                
                                background: Rectangle { color: theme.background; border.color: theme.primary; border.width: 1; radius: 8 }
                                ML4WMenuItem { text: "Select Sidepad"; onClicked: {
                                        appLauncher.running = false
                                        appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-sidepad --select"]
                                        appLauncher.running = true
                                    } 
                                }
                                ML4WMenuItem { text: "Open Sidepad Folder"; onClicked: {
                                        appLauncher.running = false
                                        appLauncher.command = ["nautilus", Quickshell.env("HOME") + "/.config/sidepad/pads"]
                                        appLauncher.running = true
                                    } 
                                }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: theme.primary; opacity: 0.3; Layout.topMargin: 5; Layout.bottomMargin: 5 }

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
                                appLauncher.command = ["waypaper"]
                                appLauncher.running = true
                            }
                        }
                        SettingsWheel {
                            onClicked: wallpaperMenu.open()
                            Menu {
                                id: wallpaperMenu
                                y: parent.height
                                
                                implicitWidth: 220
                                padding: 8
                                
                                background: Rectangle { color: theme.background; border.color: theme.primary; border.width: 1; radius: 8 }
                                ML4WMenuItem { text: "Random Wallpaper"; onClicked: {
                                        root.isOpen = false
                                        appLauncher.running = false
                                        appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/waypaper.sh --random"]
                                        appLauncher.running = true
                                    } 
                                }
                                ML4WMenuItem { text: "Wallpaper Effects"; onClicked: {
                                        root.isOpen = false
                                        appLauncher.running = false
                                        appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/wallpaper-effects.sh"]
                                        appLauncher.running = true
                                    } 
                                }
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
                                appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/themes/themes.sh"]
                                appLauncher.running = true
                            }
                        }
                        SettingsWheel {
                            onClicked: themeMenu.open()
                            Menu {
                                id: themeMenu
                                y: parent.height
                                
                                implicitWidth: 220
                                padding: 8
                                
                                background: Rectangle { color: theme.background; border.color: theme.primary; border.width: 1; radius: 8 }
                                ML4WMenuItem { text: "Set GTK Theme"; onClicked: {
                                        root.isOpen = false
                                        appLauncher.running = false
                                        appLauncher.command = ["nwg-look"]
                                        appLauncher.running = true
                                    } 
                                }
                                ML4WMenuItem { text: "Set QT Theme"; onClicked: {
                                        root.isOpen = false
                                        appLauncher.running = false
                                        appLauncher.command = ["qt6ct"]
                                        appLauncher.running = true
                                    }
                                }
                                ML4WMenuItem { text: "Refresh GTK Theme"; onClicked: {
                                        root.isOpen = false
                                        appLauncher.running = false
                                        appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/gtk.sh"]
                                        appLauncher.running = true
                                    } 
                                }
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
                                appLauncher.command = ["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/screenshot.sh"]
                                appLauncher.running = true
                            }
                        }
                        Item { implicitWidth: 28 } 
                    }
                }
            }
        }
    }
}