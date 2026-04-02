import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland 
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import qs.shared

PanelWindow {
    id: root
    
    // --- WAYLAND CONFIGURATION ---
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: WlrLayershell.Ignore
    
    implicitWidth: 380
    color: "transparent"

    // --- POSITIONING ---
    anchors {
        left: true
        top: true
        bottom: true
    }

    margins { 
        top: 87
        bottom: 20
    }

    // --- CLICK OUTSIDE TO CLOSE ---
    HyprlandFocusGrab {
        windows: [root]
        active: root.isOpen
        onCleared: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- ESCAPE KEY LISTENER ---
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- ANIMATION LOGIC ---
    property bool isOpen: false
    visible: isOpen || slideAnim.running
    
    margins { left: root.currentMargin }
    property real currentMargin: isOpen ? 20 : -450 

    Behavior on currentMargin {
        NumberAnimation {
            id: slideAnim
            duration: 250
            easing.type: Easing.OutQuint 
        }
    }

    // --- IPC HANDLER ---
    IpcHandler {
        target: "wallpaper"
        function toggle(): void { root.isOpen = !root.isOpen }
        function open(): void { root.isOpen = true }   
        function close(): void { root.isOpen = false } 
    }

    Theme { id: theme }

    // Default fallback folder just in case the file doesn't exist
    property string wallpaperFolder: "file://" + Quickshell.env("HOME") + "/.config/ml4w/wallpapers"

    Process {
        id: folderLoader
        // Call cat directly and pass the path as the second array item
        command: ["cat", Quickshell.env("HOME") + "/.config/ml4w/settings/wallpaper-folder"]
        running: true
        
        stdout: StdioCollector {
            onStreamFinished: {
                let rawPath = this.text.trim();
                
                if (rawPath !== "") {
                    rawPath = rawPath.replace("$HOME", Quickshell.env("HOME"));
                    rawPath = rawPath.replace("~", Quickshell.env("HOME"));
                    // Ensure the path starts with file:// for the FolderListModel
                    let newPath = rawPath.startsWith("file://") ? rawPath : "file://" + rawPath;
                    if (root.wallpaperFolder === newPath) {
                        root.wallpaperFolder = "";
                    }
                    root.wallpaperFolder = newPath + "123";
                }
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

    // ==========================================
    // MAIN PANEL BACKGROUND & UI
    // ==========================================
    Rectangle {
        anchors.fill: parent
        color: theme ? theme.background : "#1e1e2e"
        border.color: theme ? theme.primary : "#89b4fa"
        border.width: 2
        radius: 10
        opacity: 0.95
        clip: true
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15

            // --- HEADER CONTROLS (Search & Settings) ---
            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 5
                spacing: 10

                // Search Input
                TextField {
                    id: searchInput
                    placeholderText: "Search image"
                    color: theme ? theme.primary : "#89b4fa"
                    font.pixelSize: 14
                    padding:8
                    Layout.fillWidth: true
                    horizontalAlignment: TextInput.AlignHCenter
                    
                    // opacity: activeFocus || text.length > 0 ? 1.0 : 0.7
                    
                    background: Rectangle {
                        anchors.fill: parent
                        color: theme.background
                        radius: 10
                        border.color: theme.primary
                        border.width: 1
                    }
                }

                // Settings Wheel & Menu
                SettingsWheel {
                    onClicked: wallpaperMenu.open()
                    
                    Menu {
                        id: wallpaperMenu
                        y: parent.height
                        
                        implicitWidth: 220
                        padding: 8
                        
                        background: Rectangle { 
                            color: theme.background 
                            border.color: theme.primary 
                            border.width: 1 
                            radius: 8 
                        }
                        
                        ML4WMenuItem { 
                            text: "Random Wallpaper"
                            onClicked: {
                                root.isOpen = false
                                Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-wallpaper --random"])
                            } 
                        }
                        
                        ML4WMenuItem { 
                            text: "Wallpaper Effects"
                            onClicked: {
                                root.isOpen = false
                                Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-wallpaper-effects"])
                            } 
                        }

                        ML4WMenuItem { 
                            text: "Clear Wallpaper Cache"
                            onClicked: {
                                root.isOpen = false
                                Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-clear-wallpaper-cache"])
                            } 
                        }

                        ML4WMenuItem { 
                            text: "Reload Images"
                            onClicked: {
                                folderLoader.running = true;
                            } 
                        }

                    }
                }
            }

            Rectangle { 
                Layout.fillWidth: true
                implicitHeight: 1
                color: theme ? theme.primary : "#89b4fa"
                opacity: 0.3 
            }

            // --- IMAGE GRID ---
            GridView {
                id: grid
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                
                // --- SCROLLING PERFORMANCE FIX ---
                cacheBuffer: 3000
                reuseItems: true 
                
                cellWidth: width / 2
                cellHeight: cellWidth * 0.80

                ScrollBar.vertical: ScrollBar {
                    interactive: true
                }

                model: FolderListModel {
                    folder: root.wallpaperFolder
                    showDirs: false
                    caseSensitive: false
                    
                    sortField: FolderListModel.Name
                    
                    nameFilters: {
                        let s = searchInput.text.trim();
                        if (s === "") {
                            return ["*.jpg", "*.jpeg", "*.png"];
                        }
                        return ["*" + s + "*.jpg", "*" + s + "*.jpeg", "*" + s + "*.png"];
                    }
                }

                delegate: Item {
                    width: grid.cellWidth
                    height: grid.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 8 
                        color: theme.secondary 
                        
                        border.color: mouseArea.containsMouse ? theme.primary : "transparent"
                        border.width: 2
                        radius: 10
                        clip: true

// --- NEW: The invisible mask shape defining the 10px rounded corners ---
                        Rectangle {
                            id: contentMask
                            anchors.fill: parent
                            anchors.margins: 2 
                            radius: 8
                            visible: false
                        }

                        // --- NEW: Wrapper applying the OpacityMask to the image & label ---
                        Item {
                            anchors.fill: parent
                            anchors.margins: 2
                            
                            layer.enabled: true
                            layer.effect: OpacityMask {
                                maskSource: contentMask
                            }

                            BusyIndicator {
                                anchors.centerIn: parent
                                width: 30
                                height: 30
                                running: thumbnail.status === Image.Loading
                                opacity: running ? 0.5 : 0.0
                            }

                            Image {
                                id: thumbnail 
                                anchors.fill: parent 
                                source: "file://" + model.filePath 
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                sourceSize.width: 250
                                sourceSize.height: 250
                                
                                opacity: status === Image.Ready ? 1.0 : 0.0
                                Behavior on opacity {
                                    NumberAnimation { 
                                        duration: 350 
                                        easing.type: Easing.OutCubic 
                                    }
                                }
                                
                                onStatusChanged: {
                                    if (status === Image.Error) {
                                        console.log("Failed to load image at: " + source);
                                    }
                                }
                            }

                            // The text label gets beautifully clipped by the rounded mask at the bottom corners too!
                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right
                                height: 22
                                color: "#aa000000" 
                                
                                Text {
                                    anchors.centerIn: parent
                                    text: model.fileName
                                    color: "white"
                                    font.pixelSize: 11
                                    elide: Text.ElideRight
                                    width: parent.width - 8
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                let scriptPath = Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-wallpaper";
                                Quickshell.execDetached(["bash", "-c", scriptPath + " '" + model.filePath + "'"]);
                            }
                        }
                    }
                }
            }
        }
    }
}