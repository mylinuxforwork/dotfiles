import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import qs.shared

FloatingWindow {
    id: root
    visible: false
    title: "ML4W Welcome"
    implicitWidth: 850
    implicitHeight: 550

    // --- Guard property for the flatpak app ---
    property bool isHyprlandSettingsInstalled: false

    IpcHandler {
        target: "welcome"
        function toggle(): void {
            root.visible = !root.visible
        }
    }

    Theme {
        id: theme
    }

    // --- Check if flatpak is installed when window opens ---
    Process {
        command: ["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-flatpak-installed com.ml4w.hyprlandsettings"]
        running: root.visible
        
        stdout: StdioCollector {
            onStreamFinished: {
                console.log(this.text.trim())
                // The script echoes "0" if the app exists/is installed
                root.isHyprlandSettingsInstalled = (this.text.trim() === "0")
            }
        }
    }

    // Define a custom reusable styled MenuItem
    component ML4WMenuItem: MenuItem {
        id: control
        
        contentItem: Text {
            text: control.text
            font.family: theme.fontFamily
            font.pixelSize: 14
            // Invert colors on hover
            color: control.highlighted ? theme.background : theme.primary 
            verticalAlignment: Text.AlignVCenter
        }
        
        background: Rectangle {
            implicitWidth: 220
            implicitHeight: 36
            // Apply theme color on hover
            color: control.highlighted ? theme.primary : "transparent"
            radius: 4
        }
    }

    component ML4WMenuSeparator: MenuSeparator {
        contentItem: Rectangle {
            implicitWidth: 200
            implicitHeight: 1
            color: theme.primary
            opacity: 0.3 // Dim the line so it doesn't distract from text
        }
    }

    color: theme.background

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ==========================================
        // TRADITIONAL MENU BAR
        // ==========================================
        MenuBar {
            Layout.fillWidth: true
            Layout.margins: 10
            background: Rectangle {
                color: theme.primary
                border.color: theme.primary
                radius: 8
            }

            // --- SETTINGS MENU ---
            Menu {
                title: qsTr("Settings")
                font.family: theme.fontFamily
                font.pixelSize: 14
                padding:8

                enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200; easing.type: Easing.OutQuad } }
                exit: Transition { NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 150; easing.type: Easing.InQuad } }

                ML4WMenuItem { 
                    text: qsTr("Keyboard");
                    onClicked: {
                        Quickshell.execDetached(["gnome-text-editor", Quickshell.env("HOME") + "/.config/hypr/conf/keyboard.conf"])
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("Monitors");
                    onClicked: { 
                        Quickshell.execDetached(["nwg-displays"])
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("Network");
                    onClicked: { 
                        Quickshell.execDetached(["kitty", "--class", "dotfiles-floating", "-e", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-network"])
                    }
                }    
                ML4WMenuItem { 
                    text: qsTr("Bluetooth");
                    onClicked: { 
                        Quickshell.execDetached(["blueman-manager"])
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("Wallpaper");
                    onClicked: { 
                        Quickshell.execDetached(["waypaper"])
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("Theme");
                    onClicked: { 
                        Quickshell.execDetached(["nwg-look"])
                    }
                }
                ML4WMenuSeparator {}
                ML4WMenuItem { 
                    text: qsTr("Dotfiles Settings");
                    onClicked: {
                        Quickshell.execDetached(["qs", "-p", Quickshell.env("HOME") + "/.local/share/ml4w-dotfiles-settings/quickshell", "ipc", "call", "settings", "toggle"])
                    }
                }
                ML4WMenuItem { 
                    text: root.isHyprlandSettingsInstalled ? qsTr("Hyprland Settings") : qsTr("Install Hyprland Settings")
                    onClicked: { 
                        if (root.isHyprlandSettingsInstalled) {
                            Quickshell.execDetached(["bash","-c","flatpak run com.ml4w.hyprlandsettings"])
                        } else {
                            Quickshell.execDetached(["kitty", "--class", "dotfiles-floating", "-e", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-install-hyprlandsettings"])
                        }
                    }
                }
                background: Rectangle {
                    implicitWidth: 220
                    color: theme.background
                    border.color: theme.primary
                    border.width: 1
                    radius: 8
                }
            }

            // --- System MENU ---
            Menu {
                title: qsTr("System")
                font.family: theme.fontFamily
                font.pixelSize: 14
                padding:8
                
                enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200; easing.type: Easing.OutQuad } }
                exit: Transition { NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 150; easing.type: Easing.InQuad } }

                ML4WMenuItem { 
                    text: qsTr("Display Manager");
                    onClicked: { 
                        Quickshell.execDetached(["kitty", "--class", "dotfiles-floating", "-e", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-install-sddm"]) 
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("Network Manager Applet");
                    onClicked: { 
                        Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-toggle-nmapplet"])
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("Change Shell");
                    onClicked: { 
                        Quickshell.execDetached(["kitty", "--class", "dotfiles-floating", "-e", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-change-shell"])
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("System Info") 
                    onClicked: { 
                        Quickshell.execDetached(["kitty", "--class", "dotfiles-floating", "-e", Quickshell.env("HOME") + "/.config/hypr/scripts/systeminfo.sh"])
                    }
                }
                ML4WMenuSeparator {}
                ML4WMenuItem { 
                    text: qsTr("Exit Hyprland") 
                    onClicked: {
                        Quickshell.execDetached(["bash", "-c", "qs ipc call power toggle"])
                    }
                }

                background: Rectangle {
                    implicitWidth: 220
                    color: theme.background
                    border.color: theme.primary
                    border.width: 1
                    radius: 8
                }
            }

            // --- HELP MENU ---
            Menu {
                title: qsTr("Help")
                font.family: theme.fontFamily
                font.pixelSize: 14
                padding:8
                
                enter: Transition { NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200; easing.type: Easing.OutQuad } }
                exit: Transition { NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 150; easing.type: Easing.InQuad } }

                ML4WMenuItem { text: qsTr("ML4W OS Homepage"); onClicked: { 
                    Quickshell.execDetached(["xdg-open", "https://ml4w.com/os/"])
                    }
                }
                ML4WMenuItem { text: qsTr("ML4W OS GitHub"); onClicked: { 
                    Quickshell.execDetached(["xdg-open", "https://github.com/mylinuxforwork/dotfiles"]) 
                    } 
                }
                ML4WMenuItem { text: qsTr("ML4W OS Changelog"); onClicked: { 
                    Quickshell.execDetached(["xdg-open", "https://github.com/mylinuxforwork/dotfiles/blob/main/CHANGELOG.md"]) 
                    } 
                }
                ML4WMenuItem { text: qsTr("ML4W YouTube Channel"); onClicked: { 
                    Quickshell.execDetached(["xdg-open", "https://www.youtube.com/channel/UC0sUzmZ0CHvVCVrpRfGKZfw"]) 
                    } 
                }
                ML4WMenuItem { text: qsTr("Get more Wallpapers"); onClicked: { 
                    Quickshell.execDetached(["xdg-open", "https://github.com/mylinuxforwork/wallpaper"]) 
                    } 
                }
                ML4WMenuSeparator {}
                ML4WMenuItem { text: qsTr("Hyprland Homepage"); onClicked: { 
                    Quickshell.execDetached(["xdg-open", "https://github.com/mylinuxforwork/wallpaper"]) 
                    } 
                }
                ML4WMenuItem { text: qsTr("Hyprland Wiki"); onClicked: { 
                    Quickshell.execDetached(["xdg-open", "https://github.com/mylinuxforwork/wallpaper"]) 
                    } 
                }
                ML4WMenuItem { text: qsTr("Update ML4W OS"); onClicked: { 
                    Quickshell.execDetached(["xdg-open", "https://github.com/mylinuxforwork/wallpaper"]) 
                    } 
                }

                background: Rectangle {
                    implicitWidth: 180
                    color: theme.background
                    border.color: theme.primary
                    radius: 8
                }
            }

            // --- UNIVERSAL STYLING FOR ALL MENUS ---
            delegate: MenuBarItem {
                id: menuBarItem
                contentItem: Text {
                    text: menuBarItem.text
                    font.pixelSize: 14
                    font.family: theme.fontFamily
                    color: theme.on_primary
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: "transparent"
                    radius: theme.on_primary
                }
            }
        }

        // ==========================================
        // MAIN CONTENT AREA
        // ==========================================
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                // --- MAIN HERO SECTION --- 
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10
                    Layout.topMargin: 20

                    Image {
                        Layout.alignment: Qt.AlignHCenter
                        source: "../shared/ml4w.svg"
                        sourceSize.width: 100 
                        sourceSize.height: 100
                        width: 100
                        height: 100
                        fillMode: Image.PreserveAspectFit
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Welcome to ML4W OS"
                        font.family: theme.fontFamily
                        font.pixelSize: 28
                        font.bold: true
                        color: theme.on_background
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        font.family: theme.fontFamily
                        text: "Dotfiles for Hyprland"
                        font.pixelSize: 20
                        font.bold: true
                        color: theme.on_background
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Version 2.12.0"
                        font.family: theme.fontFamily
                        font.pixelSize: 16
                        color: theme.on_background
                        Layout.bottomMargin: 10
                    }

                    // Action Buttons
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 15

                        Button {
                            text: "Dotfiles Settings"
                            onClicked: {
                                Quickshell.execDetached(["qs", "-p", Quickshell.env("HOME") + "/.local/share/ml4w-dotfiles-settings/quickshell", "ipc", "call", "settings", "toggle"])
                            }
                            background: Rectangle {
                                color: "transparent"
                                radius: 10
                                border.color: theme.primary
                            }
                            contentItem: Text {
                                text: parent.text
                                font.family: theme.fontFamily
                                color: theme.primary
                                padding: 8
                            }
                        }

                        // --- VISIBILITY BOUND TO GUARD PROPERTY ---
                        Button {
                            text: "Hyprland Settings"
                            visible: root.isHyprlandSettingsInstalled 
                            
                            onClicked: {
                                Quickshell.execDetached(["flatpak", "run", "com.ml4w.hyprlandsettings"])
                            }
                            background: Rectangle {
                                color: "transparent"
                                radius: 10
                                border.color: theme.primary
                            }
                            contentItem: Text {
                                text: parent.text
                                font.family: theme.fontFamily
                                color: theme.primary
                                padding: 8
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true } // Spacer

                // --- KEYBINDINGS GRID ---
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 8

                    Repeater {
                        model: ListModel {
                            ListElement { keys: "Super + Enter"; desc: "to open the terminal" }
                            ListElement { keys: "Super + B"; desc: "to open the browser" }
                            ListElement { keys: "Super + Space"; desc: "to open the application launcher" }
                            ListElement { keys: "Super + Q"; desc: "to close the active window" }
                        }
                        
                        delegate: RowLayout {
                            spacing: 15
                            
                            Text {
                                text: model.keys
                                color: theme.primary
                                font.family: theme.fontFamily
                                font.bold: true
                                font.pixelSize: 13
                                Layout.preferredWidth: 120
                                horizontalAlignment: Text.AlignRight
                            }
                            
                            Text {
                                text: model.desc
                                color: theme.on_background
                                font.family: theme.fontFamily
                                font.pixelSize: 13
                                Layout.preferredWidth: 240
                            }
                        }
                    }

                    Button {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 15
                        text: "All keybindings"

                        onClicked: {
                            Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/keybindings.sh"])
                        }

                        background: Rectangle {
                            color: "transparent"
                            border.color: theme.primary
                            radius: 10
                        }
                        contentItem: Text {
                            text: parent.text
                            font.family: theme.fontFamily
                            color: theme.primary
                            padding: 8
                        }
                    }
                }
                
                Item { Layout.fillHeight: true } 

                // ==========================================
                // BOTTOM BAR
                // ==========================================
                RowLayout {
                    Layout.fillWidth: true
                    Layout.margins: 10

                    // --- NEW TOGGLE BUTTON (Left Side) ---
                    Button {
                        text: "Toggle Tiling/Floating"
                        
                        // Styled to be slightly smaller and compact
                        background: Rectangle {
                            color: "transparent"
                            border.color: theme.primary
                            border.width: 1
                            radius: 6
                        }
                        
                        contentItem: Text {
                            text: parent.text
                            font.family: theme.fontFamily
                            font.pixelSize: 12 // Smaller text size
                            color: theme.primary
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            padding: 4
                            leftPadding: 10
                            rightPadding: 10
                        }
                        
                        onClicked: {
                            Quickshell.execDetached(["hyprctl", "dispatch", "togglefloating"])
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: qsTr("Show on Startup")
                        color: theme.primary
                        font.family: theme.fontFamily
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Switch {
                        id: autostartSwitch
                        Layout.alignment: Qt.AlignVCenter
                        
                        implicitWidth: 48
                        implicitHeight: 26

                        property bool ready: false

                        Process {
                            command: ["bash", "-c", "test -f ~/.cache/ml4w-welcome-autostart && echo exists || echo missing"]
                            running: root.visible
                            stdout: StdioCollector {
                                onStreamFinished: {
                                    let output = this.text.trim()
                                    if (output === "exists") {
                                        autostartSwitch.checked = false 
                                    } else if (output === "missing") {
                                        autostartSwitch.checked = true  
                                    }
                                    autostartSwitch.ready = true
                                }
                            }
                        }

                        indicator: Rectangle {
                            implicitWidth: 48
                            implicitHeight: 26
                            radius: 13
                            
                            color: autostartSwitch.checked ? theme.primary : theme.background
                            border.color: theme.primary
                            border.width: 1

                            Rectangle {
                                x: autostartSwitch.checked ? parent.width - width - 2 : 2
                                y: 2
                                width: 22
                                height: 22 
                                radius: 11
                                color: autostartSwitch.checked ? theme.background : theme.on_primary
                                Behavior on x { NumberAnimation { duration: 150 } }
                            }
                        }

                        onClicked: {
                            if (!ready) return;
                            if (checked) {
                                Quickshell.execDetached(["rm", "-f", Quickshell.env("HOME") + "/.cache/ml4w-welcome-autostart"])
                            } else {
                                Quickshell.execDetached(["touch", Quickshell.env("HOME") + "/.cache/ml4w-welcome-autostart"])
                            }
                        }
                    }
                }                
            }
        }
    }
}
