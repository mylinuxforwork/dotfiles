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
    width: 850
    height: 550

    IpcHandler {
        target: "welcome"
        function toggle(): void {
            root.visible = !root.visible
        }
    }

    Theme {
        id: theme
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
            
            // Background of the entire menu bar
            background: Rectangle {
                color: theme.primary
                border.color: theme.primary
                border.width: 1
            }

            // --- SETTINGS MENU ---
            Menu {
                title: qsTr("Settings")
                font.family: theme.fontFamily
                font.pixelSize: 14
                MenuItem { text: qsTr("Keyboard"); onClicked: console.log("Keyboard clicked") }
                MenuItem { text: qsTr("Monitors"); onClicked: console.log("Monitors clicked") }
                MenuItem { text: qsTr("Network"); onClicked: console.log("Network clicked") }
                MenuItem { text: qsTr("Bluetooth"); onClicked: console.log("Bluetooth clicked") }
                MenuSeparator { }
                MenuItem { text: qsTr("ML4W Dotfiles Settings") }
                MenuItem { text: qsTr("ML4W Hyprland Settings") }
                MenuSeparator { }
                MenuItem { text: qsTr("Exit Hyprland") }

                // Styling the dropdown menu background
                background: Rectangle {
                    implicitWidth: 220
                    color: theme.background
                    border.color: theme.primary
                    radius: 0
                }
            }

            // --- HELP MENU ---
            Menu {
                title: qsTr("Help")
                font.family: theme.fontFamily
                font.pixelSize: 14

                MenuItem { text: qsTr("Documentation") }
                MenuItem { text: qsTr("Keybindings List") }
                MenuSeparator { }
                MenuItem { text: qsTr("About ML4W") }

                background: Rectangle {
                    implicitWidth: 180
                    color: theme.background
                    border.color: theme.primary
                    radius: 0
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
                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 80
                        height: 80
                        radius: 16
                        color: "#00d2ff" // Cyan brand color
                        
                        Text {
                            anchors.centerIn: parent
                            text: "ml."
                            font.pixelSize: 32
                            font.bold: true
                            color: "#11111b"
                        }
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

                    Component {
                        id: shortcutRow
                        RowLayout {
                            spacing: 15
                            property string keys: ""
                            property string desc: ""
                            
                            Text {
                                text: keys
                                color: theme.primary
                                font.bold: true
                                font.pixelSize: 13
                                Layout.preferredWidth: 120
                                horizontalAlignment: Text.AlignRight
                            }
                            Text {
                                text: desc
                                color: theme.primary
                                font.pixelSize: 13
                                Layout.fillWidth: true
                            }
                        }
                    }

                    Loader { sourceComponent: shortcutRow; property string keys: "Super + Enter"; property string desc: "to open the terminal" }
                    Loader { sourceComponent: shortcutRow; property string keys: "Super + B"; property string desc: "to open the browser" }
                    Loader { sourceComponent: shortcutRow; property string keys: "Super + Space"; property string desc: "to open the application launcher" }

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