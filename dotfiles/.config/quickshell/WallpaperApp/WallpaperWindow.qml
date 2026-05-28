import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland 
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import QtQuick.Effects
import qs.CustomTheme

PanelWindow {
    id: root
    
    // --- WAYLAND CONFIGURATION ---
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: WlrLayershell.Ignore
    
    implicitWidth: 420 // 380 + 40
    color: "transparent"

    // --- POSITIONING ---
    anchors {
        left: true
        top: true
        bottom: true
    }

    margins { 
        top: 67
        bottom: 0
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
    property real currentMargin: isOpen ? 0 : -470 

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

    property string defaultWallpaperFolder: Quickshell.env("HOME") + "/.config/ml4w/wallpapers"
    property string wallpaperSettingFile: Quickshell.env("HOME") + "/.config/ml4w/settings/wallpaper-folder"

    // Start as default in case file does not exist
    property string wallpaperFolder: defaultWallpaperFolder

    FileView {
        id: wallpaperDirSettingFileHandler
        path: Qt.url(root.wallpaperSettingFile)
        blockLoading: true
        watchChanges: true
        onFileChanged: {
            this.reload();
            const settingValue = this.text().trim()
            console.log("Wallpaper directory setting changed on disk; attempting to load directory \"" + settingValue + "\"")
            updateWallpaperFolder(settingValue)
        }
        onLoaded: {
            const settingValue = this.text().trim()
            console.log("Loading wallpaper directory \"" + settingValue + "\"")
            updateWallpaperFolder(settingValue)
        }
        onSaved: {
            const settingValue = this.text().trim()
            console.log("Wallpaper directory setting saved successfully; reloading from directory \"" + settingValue + "\"")
            updateWallpaperFolder(this.text().trim())
        }
    }

    property string defaultTransitionEffect: "simple"
    property string transitionEffectSettingFile: Quickshell.env("HOME") + "/.config/ml4w/settings/wallpaper-transition-effect"
    property var transitionEffects: ["simple", "left", "right", "top", "bottom", "center", "any", "random", "none"]
    property string transitionEffect: defaultTransitionEffect

    FileView {
        id: transitionEffectSettingFileHandler
        path: Qt.url(root.transitionEffectSettingFile)
        blockLoading: true
        watchChanges: true
        onFileChanged: {
            this.reload();
            const settingValue = this.text().trim()
            console.log("Transition effect setting changed on disk; attempting to update to \"" + settingValue + "\"")
            updateTransitionEffect(settingValue)
        }
        onLoaded: {
            const settingValue = this.text().trim()
            console.log("Loading transition effect \"" + settingValue + "\"")
            updateTransitionEffect(settingValue)
        }
        onSaved: {
            const settingValue = this.text().trim()
            console.log("Transition effect setting saved successfully; updating to \"" + settingValue + "\"")
            updateTransitionEffect(this.text().trim())
        }
    }

    function advancedSettingsLabel(): string {
        const actionText = advancedOptions.visible ? "Hide" : "Show"
        return actionText + " Advanced Options"
    }

    function updateWallpaperFolder(dirString): void {
        root.wallpaperFolder = dirString.replace(/~|\$HOME/g, Quickshell.env("HOME"))
    }

    function updateTransitionEffect(effectString): void {
        const cleaned = effectString.trim();
        if (root.transitionEffects.indexOf(cleaned) !== -1) {
            root.transitionEffect = cleaned;
        } else {
            root.transitionEffect = "simple";
        }
    }

    // --- REUSABLE COMPONENTS ---
    component ML4WMenuItem: MenuItem {
        id: control
        contentItem: Text {
            text: control.text
            font.family: Theme.fontFamily
            font.pixelSize: 14
            color: control.highlighted ? Theme.background : Theme.primary 
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 36
            color: control.highlighted ? Theme.primary : "transparent"
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
            text: parent.text; color: Theme.primary; font.pixelSize: 18; 
            verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 20

        RectangularShadow {
            id: shadow
            anchors.fill: mainBgRect
            radius: mainBgRect.radius
            blur: 15
            color: Qt.rgba(Theme.shadow.r, Theme.shadow.g, Theme.shadow.b, 0.4)
        }

        Rectangle {
            id: mainBgRect
            anchors.fill: parent
            color: Theme.background
            border.color: Theme.primary
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
                    color: Theme.primary
                    font.pixelSize: 14
                    padding:8
                    Layout.fillWidth: true
                    horizontalAlignment: TextInput.AlignHCenter
                    
                    // opacity: activeFocus || text.length > 0 ? 1.0 : 0.7
                    
                    background: Rectangle {
                        anchors.fill: parent
                        color: Theme.background
                        radius: 10
                        border.color: Theme.primary
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
                            color: Theme.background 
                            border.color: Theme.primary 
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

                        ML4WMenuItem {
                            text: advancedSettingsLabel()
                            onClicked: {
                                advancedOptions.visible = !advancedOptions.visible
                            }
                        }

                    }
                }
            }

            // --- ADVANCED OPTIONS ---
            ColumnLayout {
                id: advancedOptions
                Layout.fillWidth: true
                Layout.topMargin: 5
                spacing: 10
                visible: false

                // --- WALLPAPER DIRECTORY SETTING ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Label {
                        id: wallpaperDirInputLabel
                        color: Theme.primary
                        font.family: Theme.fontFamily

                        text: "Wallpaper Folder"

                        Accessible.name: text
                        Accessible.role: Accessible.StaticText
                    }

                    TextField {
                        id: wallpaperDirInput
                        color: Theme.primary
                        font.pixelSize: 14
                        padding: 8
                        Layout.fillWidth: true
                        horizontalAlignment: TextInput.AlignHCenter

                        Accessible.name: wallpaperDirInputLabel.text
                        Accessible.description: qsTr("Enter the full path to your wallpaper folder")
                        Accessible.role: Accessible.EditableText

                        placeholderText: "Specify wallpaper directory"
                        text: wallpaperDirSettingFileHandler.text().trim()

                        onAccepted: {
                            console.log("Updating wallpaper directory to \"" + this.text + "\"")
                            wallpaperDirSettingFileHandler.setText(this.text)
                        }

                        background: Rectangle {
                            anchors.fill: parent
                            color: Theme.background
                            radius: 10
                            border.color: Theme.primary
                            border.width: 1
                        }
                    }
                }

                // --- WALLPAPER TRANSITION EFFECT SETTING ---
                ColumnLayout {
                    Layout.fillWidth: true
                    Label {
                        id: transitionEffectInputLabel
                        color: Theme.primary
                        font.family: Theme.fontFamily

                        text: "Transition Effect"

                        Accessible.name: text
                        Accessible.role: Accessible.StaticText
                    }

                    ComboBox {
                        id: transitionEffectComboBox
                        model: root.transitionEffects
                        currentIndex: root.transitionEffects.indexOf(root.transitionEffect)
                        Layout.fillWidth: true

                        onActivated: {
                            const selectedEffect = root.transitionEffects[index];
                            console.log("Updating wallpaper transition effect to \"" + selectedEffect + "\"")
                            transitionEffectSettingFileHandler.setText(selectedEffect)
                        }

                        delegate: ItemDelegate {
                            id: itemDelegate
                            width: transitionEffectComboBox.width
                            contentItem: Text {
                                text: modelData
                                color: itemDelegate.highlighted ? Theme.background : Theme.primary
                                font.family: Theme.fontFamily
                                font.pixelSize: 14
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                            }
                            background: Rectangle {
                                color: itemDelegate.highlighted ? Theme.primary : "transparent"
                                radius: 4
                            }
                            highlighted: transitionEffectComboBox.highlightedIndex === index
                        }

                        indicator: Canvas {
                            id: canvas
                            x: transitionEffectComboBox.width - width - 12
                            y: (transitionEffectComboBox.height - height) / 2
                            width: 12
                            height: 8
                            contextType: "2d"

                            onPaint: {
                                context.reset();
                                context.moveTo(0, 0);
                                context.lineTo(width, 0);
                                context.lineTo(width / 2, height);
                                context.closePath();
                                context.fillStyle = Theme.primary;
                                context.fill();
                            }

                            Connections {
                                target: transitionEffectComboBox
                                function onPressedChanged() { canvas.requestPaint(); }
                            }
                        }

                        contentItem: Text {
                            leftPadding: 12
                            rightPadding: transitionEffectComboBox.indicator.width + 12
                            text: transitionEffectComboBox.displayText
                            font.family: Theme.fontFamily
                            font.pixelSize: 14
                            color: Theme.primary
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        background: Rectangle {
                            implicitHeight: 36
                            color: Theme.background
                            border.color: Theme.primary
                            border.width: 1
                            radius: 10
                        }

                        popup: Popup {
                            y: transitionEffectComboBox.height + 2
                            width: transitionEffectComboBox.width
                            implicitHeight: contentItem.contentHeight > 250 ? 250 : contentItem.contentHeight
                            padding: 4

                            contentItem: ListView {
                                clip: true
                                implicitHeight: contentHeight
                                model: transitionEffectComboBox.popup.visible ? transitionEffectComboBox.delegateModel : null
                                currentIndex: transitionEffectComboBox.highlightedIndex

                                ScrollIndicator.vertical: ScrollIndicator { }
                            }

                            background: Rectangle {
                                color: Theme.background
                                border.color: Theme.primary
                                border.width: 1
                                radius: 8
                            }
                        }
                    }
                }
            }

            Rectangle { 
                Layout.fillWidth: true
                implicitHeight: 1
                color: Theme.primary
                opacity: 0.3 
            }

            // --- ERROR MSG FOR EMPTY OR INVALID DIRECTORY ---
            Text {
                id: emptyWallpaperDirectoryMsg
                visible: true

                Layout.fillWidth: true
                color: Theme.primary
                font.family: Theme.fontFamily
                wrapMode: Text.WordWrap
                Layout.alignment: Qt.AlignHCenter
                horizontalAlignment: Text.AlignHCenter

                text: "Wallpaper folder is either empty or invalid."
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
                    folder: "file://" + root.wallpaperFolder
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

                    onCountChanged: {
                        emptyWallpaperDirectoryMsg.visible = (count === 0 && this.status === FolderListModel.Ready)
                    }
                }

                delegate: Item {
                    width: grid.cellWidth
                    height: grid.cellHeight

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 8 
                        color: Theme.secondary 
                        
                        border.color: mouseArea.containsMouse ? Theme.primary : "transparent"
                        border.width: 2
                        radius: 10
                        clip: true

                        Rectangle {
                            id: contentMask
                            anchors.fill: parent
                            anchors.margins: 2 
                            radius: 8
                            visible: false
                        }

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
}
