import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../shared" // Pulls in Theme.qml from the shared folder

FloatingWindow {
    id: root
    visible: false
    title: "ML4W Settings"
    width: 900
    height: 600

    IpcHandler {
        target: "settings"
        function toggle(): void {
            root.visible = !root.visible
        }
    }

    // Instantiate the shared Theme
    Theme {
        id: theme
    }

    color: theme.bgMain 

    property string profile: "com.ml4w.dotfiles" 
    // Absolute path to your script to prevent system PATH issues
    property string scriptPath: Quickshell.env("HOME") + "/.local/bin/ml4w-dotfiles-settings"
    
    property var settingsData: []
    property int selectedGroupIndex: 0
    
    // Load and parse the JSON configuration on startup
    Process {
        command: ["bash", "-c", "cat ~/.config/ml4w-dotfiles-settings/" + root.profile + "/settings.json 2>&1"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var rawOutput = this.text.trim(); 
                
                if (rawOutput === "" || rawOutput.startsWith("cat: ")) {
                    console.log("ERROR: Bash could not find or load the settings.json file.");
                    return;
                }

                try {
                    root.settingsData = JSON.parse(rawOutput);
                } catch(e) {
                    console.log("Error parsing JSON: ", e);
                }
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // ==========================================
        // LEFT SIDEBAR: Group Navigation
        // ==========================================
        Rectangle {
            Layout.preferredWidth: 260
            Layout.fillHeight: true
            color: theme.bgSidebar 

            ListView {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 5
                model: root.settingsData
                
                delegate: Rectangle {
                    width: parent.width
                    height: 50
                    radius: theme.radiusLarge
                    color: index === root.selectedGroupIndex ? theme.bgCard : "transparent"
                    
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        text: modelData.group
                        font.pixelSize: 16
                        font.bold: index === root.selectedGroupIndex
                        color: index === root.selectedGroupIndex ? theme.accent : theme.textMain
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.selectedGroupIndex = index
                    }
                }
            }
        }

        // ==========================================
        // RIGHT PANE: Settings Content
        // ==========================================
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: theme.bgMain

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 40

                // Header
                Text {
                    text: root.settingsData[root.selectedGroupIndex] ? root.settingsData[root.selectedGroupIndex].group : "Loading..."
                    font.pixelSize: 28
                    font.bold: true
                    color: theme.accent
                }

                Text {
                    text: root.settingsData[root.selectedGroupIndex] ? root.settingsData[root.selectedGroupIndex].description : ""
                    font.pixelSize: 14
                    color: theme.textSub
                    Layout.bottomMargin: 20
                }

                // Settings Fields
                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    spacing: 15
                    model: root.settingsData[root.selectedGroupIndex] ? root.settingsData[root.selectedGroupIndex].settings : []

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 90
                        color: theme.bgCard 
                        radius: theme.radiusLarge

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 20

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4
                                Text {
                                    text: modelData.name
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: theme.textMain
                                }
                                Text {
                                    text: modelData.instructions
                                    font.pixelSize: 12
                                    color: theme.textSub
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }
                            }

                            // ==========================================
                            // DYNAMIC INPUT AREA (Based on JSON Type)
                            // ==========================================
                            Item {
                                id: fieldItem 
                                Layout.preferredWidth: 220
                                Layout.preferredHeight: 40

                                property string exactVal: ""
                                property var dropdownOptions: modelData.type === "choose" ? modelData.options : []

                                // 1. Fetch exact value (--get)
                                Process {
                                    command: [root.scriptPath, "--get", "--id", modelData.id, root.profile]
                                    running: true
                                    stdout: StdioCollector {
                                        onStreamFinished: {
                                            fieldItem.exactVal = this.text.trim();
                                        }
                                    }
                                }

                                // 2. Dynamically fetch files/folders list if needed
                                Process {
                                    running: modelData.type === "files" || modelData.type === "folders"
                                    command: {
                                        if (modelData.type === "files") {
                                            return ["bash", "-c", "ls -1p " + modelData.folder + " 2>/dev/null | grep -v / || true"]
                                        } else if (modelData.type === "folders") {
                                            return ["bash", "-c", "ls -1p " + modelData.folder + " 2>/dev/null | grep / | sed 's|/$||' || true"]
                                        }
                                        return ["echo", ""]
                                    }
                                    stdout: StdioCollector {
                                        onStreamFinished: {
                                            var out = this.text.trim();
                                            if (out !== "") {
                                                fieldItem.dropdownOptions = out.split("\n");
                                            }
                                        }
                                    }
                                }

                                // 3. Hidden Save Process (--set)
                                Process {
                                    id: saveProc
                                    running: false 
                                }

                                // --- UI COMPONENTS ---

                                // A. TEXTFIELD
                                Rectangle {
                                    anchors.fill: parent
                                    visible: modelData.type === "textfield"
                                    color: theme.bgInput
                                    radius: theme.radiusSmall
                                    border.color: theme.border
                                    border.width: 1

                                    TextInput {
                                        id: valInput
                                        anchors.fill: parent
                                        anchors.margins: 10
                                        verticalAlignment: Text.AlignVCenter
                                        color: theme.textMain
                                        font.pixelSize: 14
                                        text: fieldItem.exactVal

                                        Text {
                                            anchors.fill: parent
                                            verticalAlignment: Text.AlignVCenter
                                            text: "Enter value..."
                                            color: theme.placeholder
                                            visible: valInput.text === ""
                                        }

                                        onAccepted: {
                                            saveProc.command = [root.scriptPath, "--set", "--id", modelData.id, "--value", valInput.text, root.profile]
                                            saveProc.running = true
                                            fieldItem.exactVal = valInput.text
                                            valInput.focus = false
                                        }
                                    }
                                }

                                // B. TOGGLE (Switch)
                                Switch {
                                    anchors.centerIn: parent
                                    visible: modelData.type === "toggle"

                                    checked: {
                                        var tVal = modelData.true_value !== undefined ? modelData.true_value : "true"
                                        return fieldItem.exactVal === tVal
                                    }

                                    // Custom styling for the dark theme
                                    indicator: Rectangle {
                                        implicitWidth: 48
                                        implicitHeight: 26
                                        radius: 13
                                        color: parent.checked ? theme.success : theme.bgInput
                                        border.color: parent.checked ? theme.success : theme.border
                                        border.width: 1

                                        Rectangle {
                                            x: parent.parent.checked ? parent.width - width - 2 : 2
                                            y: 2
                                            width: 22
                                            height: 22
                                            radius: 11
                                            color: parent.parent.checked ? theme.bgSidebar : theme.textMain
                                            Behavior on x { NumberAnimation { duration: 150 } }
                                        }
                                    }

                                    onClicked: {
                                        var tVal = modelData.true_value !== undefined ? modelData.true_value : "true"
                                        var fVal = modelData.false_value !== undefined ? modelData.false_value : "false"
                                        var newVal = checked ? tVal : fVal

                                        saveProc.command = [root.scriptPath, "--set", "--id", modelData.id, "--value", newVal, root.profile]
                                        saveProc.running = true
                                        fieldItem.exactVal = newVal
                                    }
                                }

                                // C. DROPDOWN (ComboBox)
                                ComboBox {
                                    id: combo
                                    anchors.fill: parent
                                    visible: modelData.type === "choose" || modelData.type === "files" || modelData.type === "folders"
                                    model: fieldItem.dropdownOptions

                                    // Keep dropdown highlighted choice in sync with exact value
                                    onModelChanged: updateIndex()
                                    Connections {
                                        target: fieldItem
                                        function onExactValChanged() { combo.updateIndex() }
                                    }
                                    function updateIndex() {
                                        var idx = combo.find(fieldItem.exactVal)
                                        if (idx >= 0) combo.currentIndex = idx
                                    }

                                    onActivated: function(index) {
                                        var newVal = combo.textAt(index)
                                        saveProc.command = [root.scriptPath, "--set", "--id", modelData.id, "--value", newVal, root.profile]
                                        saveProc.running = true
                                        fieldItem.exactVal = newVal
                                    }

                                    // Custom styling for the dropdown button
                                    background: Rectangle {
                                        color: theme.bgInput
                                        border.color: theme.border
                                        radius: theme.radiusSmall
                                    }
                                    contentItem: Text {
                                        text: combo.displayText
                                        font.pixelSize: 14
                                        color: theme.textMain
                                        verticalAlignment: Text.AlignVCenter
                                        leftPadding: 10
                                    }

                                    // Custom styling for the popup menu
                                    popup: Popup {
                                        y: combo.height - 1
                                        width: combo.width
                                        implicitHeight: contentItem.implicitHeight
                                        padding: 1
                                        contentItem: ListView {
                                            clip: true
                                            implicitHeight: contentHeight
                                            model: combo.popup.visible ? combo.delegateModel : null
                                            currentIndex: combo.highlightedIndex
                                            ScrollIndicator.vertical: ScrollIndicator { }
                                        }
                                        background: Rectangle {
                                            color: theme.bgMain
                                            border.color: theme.border
                                            radius: theme.radiusSmall
                                        }
                                    }
                                    delegate: ItemDelegate {
                                        width: combo.width
                                        contentItem: Text {
                                            text: modelData
                                            color: highlighted ? theme.success : theme.textMain
                                            font.pixelSize: 14
                                            verticalAlignment: Text.AlignVCenter
                                        }
                                        background: Rectangle {
                                            color: highlighted ? theme.bgCard : "transparent"
                                        }
                                        highlighted: combo.highlightedIndex === index
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}