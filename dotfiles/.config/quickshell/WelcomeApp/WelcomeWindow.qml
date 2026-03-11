import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import "../shared" // Pulls in your universal Theme.qml

FloatingWindow {
    id: root
    visible: true
    title: "ML4W Welcome"
    implicitWidth: 850
    implicitHeight: 550

    IpcHandler {
        target: "welcome"
        function toggle(): void {
            root.visible = !root.visible
        }
    }

    Theme {
        id: theme
    }

    Process {
        id: appLauncher
        running: false
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

                ML4WMenuItem { 
                    text: qsTr("Keyboard"); 
                    onClicked: { 
                        console.log("Keyboard clicked") 
                        appLauncher.command = ["gnome-text-editor", Quickshell.env("HOME") + "/.config/hypr/conf/keyboard.conf"]
                        appLauncher.running = true                        
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("Monitors"); 
                    onClicked: { 
                        console.log("Monitors clicked") 
                        appLauncher.command = ["nwg-displays"]
                        appLauncher.running = true                        
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("Network"); 
                    onClicked: { 
                        console.log("Network clicked") 
                        appLauncher.command = ["kitty", "--class", "dotfiles-floating", "-e", "~/.config/ml4w/scripts/ml4w-install-sddm"]
                        appLauncher.running = true                        
                    }
                }    
                ML4WMenuItem { 
                    text: qsTr("Bluetooth"); 
                    onClicked: {
                        console.log("Bluetooth clicked")
                        appLauncher.command = ["blueman-manager"]
                        appLauncher.running = true                        
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("Display Manager"); 
                    onClicked: {
                        console.log("Display Manager clicked")
                        appLauncher.command = ["kitty", "--class", "dotfiles-floating", "-e", "~/.config/ml4w/scripts/ml4w-network"]
                        appLauncher.running = true                        
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("Network Manager Applet"); 
                    onClicked: {
                        console.log("Network Manager Applet clicked")
                        appLauncher.command = ["kitty", "--class", "dotfiles-floating", "-e", "~/.config/ml4w/scripts/ml4w-network"]
                        appLauncher.running = true                        
                    }
                }
                ML4WMenuItem { 
                    text: qsTr("Change Shell"); 
                    onClicked: {
                        console.log("Change Shell clicked")
                        appLauncher.command = ["kitty", "--class", "dotfiles-floating", "-e", "~/.config/ml4w/scripts/ml4w-change-shell"]
                        appLauncher.running = true                        
                    }
                }
                ML4WMenuSeparator {}
                ML4WMenuItem { 
                    text: qsTr("Exit Hyprland") 
                    onClicked: {
                        console.log("Exit Hyprland")
                        appLauncher.command = ["bash", Quickshell.env("HOME") + "/.config/hypr/scripts/power.sh exit"]
                        appLauncher.running = true                        
                    }
                }

                // Styling the dropdown menu background
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

                ML4WMenuItem { text: qsTr("Documentation") }
                ML4WMenuItem { text: qsTr("Keybindings List") }
                ML4WMenuSeparator {}
                ML4WMenuItem { text: qsTr("About ML4W") }

                background: Rectangle {
                    implicitWidth: 180
                    color: theme.background
                    border.color: theme.primary
                    radius: 8
                }
            }

            // --- UNIVERSAL STYLING FOR ALL MENUS ---
            
            // Style the top-level buttons (Settings, Help)
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
                anchors.margins: 30
                spacing: 20

                // --- MAIN HERO SECTION --- 
                ColumnLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10
                    Layout.topMargin: 20

                    // Mock Logo
                    Image {
                        Layout.alignment: Qt.AlignHCenter
                        source: "../shared/ml4w.svg"
                        
                        // Extremely important for SVGs in QML to render crisply!
                        sourceSize.width: 100 
                        sourceSize.height: 100
                        
                        // Set the actual display size
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
                        text: "Version 2.11.1"
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

                        Button {
                            text: "Hyprland Settings"
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
                                // Layout.fillWidth: true
                                Layout.preferredWidth: 240
                            }
                        }
                    }

                    Button {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.topMargin: 15
                        text: "All keybindings"
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
            }
        }
    }
}