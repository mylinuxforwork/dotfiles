import Quickshell
import Quickshell.Io
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import qs.CustomTheme

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: 20

    property bool isOpen: false
    // All sinks as [{ id, name, desc, muted }] and the current default one (name).
    property var sinks: []
    property string defaultSink: ""
    property bool fetchTick: false
    property bool micMuted: false
    property bool expanded: true
    readonly property bool defaultSinkMuted: {
        for (let i = 0; i < root.sinks.length; i++)
            if (root.sinks[i].name === root.defaultSink)
                return root.sinks[i].muted;
        return false;
    }

    // Re-list sinks and re-read the default output while the panel stays open
    // so the dropdown follows external switches (pavucontrol, wpctl, ...).
    onIsOpenChanged: {
        if (root.isOpen)
            root.kickFetch();
    }

    Timer {
        interval: 3000
        running: root.isOpen
        repeat: true
        onTriggered: root.kickFetch()
    }

    // Flipping fetchTick preserves the `running` binding instead of breaking
    // it like a direct running = true/false toggle would (same trick as
    // BrightnessControls).
    function kickFetch(): void {
        root.fetchTick = false;
        Qt.callLater(() => { root.fetchTick = true; });
    }

    // Keep the dropdown selection in sync with the actual default sink.
    function syncOutput(): void {
        let idx = -1;
        for (let i = 0; i < root.sinks.length; i++) {
            if (root.sinks[i].name === root.defaultSink) {
                idx = i;
                break;
            }
        }
        if (idx !== -1 && idx !== outputSelector.currentIndex)
            outputSelector.currentIndex = idx;
    }

    Process {
        id: soundOutputs
        // Parse the verbose listing for id, node name and friendly
        // description ("Built-in Audio Analog Stereo", "WH-1000XM4", ...).
        command: ["bash", "-c", "pactl list sinks"]
        running: root.isOpen && root.fetchTick

        stdout: StdioCollector {
            onStreamFinished: {
                let next = [];
                let cur = null;
                for (let line of this.text.split("\n")) {
                    if (line.startsWith("Sink #")) {
                        if (cur) next.push(cur);
                        cur = { id: parseInt(line.replace(/[^0-9]/g, ""), 10), name: "", desc: "", muted: false };
                    } else if (cur) {
                        if (line.startsWith("\tName: "))
                            cur.name = line.slice(7).trim();
                        else if (line.startsWith("\tDescription: "))
                            cur.desc = line.slice(14).trim();
                        else if (line.startsWith("\tMute: "))
                            cur.muted = line.slice(7).trim() === "yes";
                    }
                }
                if (cur) next.push(cur);
                next = next.filter(s => !isNaN(s.id));
                // Only replace when the list actually changed, so the
                // ComboBox model isn't reset on every poll.
                if (JSON.stringify(next) !== JSON.stringify(root.sinks)) {
                    root.sinks = next;
                }
                console.log("Sinks:", JSON.stringify(root.sinks));
                root.syncOutput();
            }
        }
    }

    Process {
        id: defaultSinkProc
        command: ["bash", "-c", "pactl get-default-sink"]
        running: root.isOpen && root.fetchTick

        stdout: StdioCollector {
            onStreamFinished: {
                root.defaultSink = this.text.trim();
                root.syncOutput();
            }
        }
    }

    // Volume of the current default sink (the one selected in the dropdown).
    Process {
        id: sinkVolumeProc
        command: ["bash", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -1 | sed 's/%//'"]
        running: root.isOpen && root.fetchTick
        stdout: StdioCollector {
            onStreamFinished: {
                let v = parseInt(this.text.trim());
                if (!isNaN(v) && !soundSlider.pressed)
                    soundSlider.value = v;
            }
        }
    }

    // Give pactl a moment to apply a new default sink before re-reading it,
    // so the slider jumps to the newly selected device's volume.
    Timer {
        id: refetchAfterSwitch
        interval: 250
        onTriggered: root.kickFetch()
    }

    Process {
        id: micStatusProc
        command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | awk '{print int($2 * 100), ($3 == \"[MUTED]\" ? 1 : 0)}'"]
        running: root.isOpen
        stdout: StdioCollector {
            onStreamFinished: {
                let parts = this.text.trim().split(" ");
                let v = parseInt(parts[0]);
                if (!isNaN(v) && !micSlider.pressed)
                    micSlider.value = v;
                root.micMuted = parts[1] === "1";
            }
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: root.isOpen
        triggeredOnStart: true
        onTriggered: micStatusProc.running = true
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 20

        SectionHeader {
            title: "Sound"
            expanded: root.expanded
            onExpandedChanged: root.expanded = expanded
        }

        // --- OUTPUT SELECTOR (default sink) ---
        RowLayout {
            Layout.fillWidth: true
            visible: root.expanded
            spacing: 10

            ComboBox {
                id: outputSelector
                Layout.fillWidth: true
                model: root.sinks
                textRole: "desc"

                // Only user picks trigger the switch; programmatic currentIndex
                // changes (syncOutput) must not.
                onActivated: (index) => {
                    let sink = root.sinks[index];
                    if (sink) {
                        console.log("Set default sink:", sink.name);
                        Quickshell.execDetached(["bash", "-c",
                            "pactl set-default-sink '" + sink.name + "'"]);
                        root.defaultSink = sink.name;
                        refetchAfterSwitch.restart();
                    }
                }

                contentItem: Text {
                    leftPadding: 10
                    rightPadding: outputSelector.indicator.width + 8
                    text: outputSelector.displayText
                    font.family: Theme.fontFamily
                    font.pixelSize: 14
                    color: Theme.primary
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                indicator: Text {
                    x: outputSelector.width - width - 12
                    y: outputSelector.topPadding + outputSelector.availableHeight / 2 - height / 2
                    text: "▼"
                    color: Theme.primary
                    font.pixelSize: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                background: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 36
                    radius: 8
                    color: outputSelector.pressed ? Theme.primary : Theme.background
                    border.color: Theme.primary
                    border.width: 1
                }

                popup: Popup {
                    y: outputSelector.height + 4
                    width: outputSelector.width
                    implicitHeight: contentItem.implicitHeight
                    padding: 4

                    background: Rectangle {
                        color: Theme.background
                        border.color: Theme.primary
                        border.width: 1
                        radius: 8
                    }

                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: outputSelector.delegateModel
                        currentIndex: outputSelector.highlightedIndex
                        ScrollIndicator.vertical: ScrollIndicator {}

                        delegate: ItemDelegate {
                            width: ListView.view.width
                            height: 36
                            highlighted: outputSelector.highlightedIndex === index

                            contentItem: Text {
                                text: outputSelector.textRole ? modelData[outputSelector.textRole] : modelData
                                color: highlighted ? Theme.background : Theme.primary
                                font.family: Theme.fontFamily
                                font.pixelSize: 14
                                elide: Text.ElideRight
                                verticalAlignment: Text.AlignVCenter
                                leftPadding: 10
                                rightPadding: 10
                            }

                            background: Rectangle {
                                color: highlighted ? Theme.primary : "transparent"
                                radius: 5
                            }
                        }
                    }
                }
            }
        }

        // --- VOLUME (selected / default sink only) ---
        RowLayout {
            Layout.fillWidth: true
            visible: root.expanded
            spacing: 15

            Image {
                source: root.defaultSinkMuted ? "../shared/icons/volume-muted.svg" : "../shared/icons/volume.svg"
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                sourceSize.width: 20
                sourceSize.height: 20
                fillMode: Image.PreserveAspectFit
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: Theme.primary
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Quickshell.execDetached(["bash", "-c", "pactl set-sink-mute @DEFAULT_SINK@ toggle"])
                        root.kickFetch()
                    }
                }
            }

            Slider {
                id: soundSlider
                Layout.fillWidth: true
                from: 0
                to: 100
                value: 50

                onMoved: {
                    Quickshell.execDetached(["bash", "-c", "pactl set-sink-volume @DEFAULT_SINK@ " + Math.round(value) + "%"]);
                }

                background: Rectangle {
                    x: soundSlider.leftPadding
                    y: soundSlider.topPadding + soundSlider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 6
                    width: soundSlider.availableWidth
                    height: implicitHeight
                    radius: 3
                    color: Theme.background
                    border.color: Theme.primary
                    border.width: 1

                    Rectangle {
                        width: soundSlider.visualPosition * parent.width
                        height: parent.height
                        color: Theme.primary
                        radius: 3
                    }
                }

                handle: Rectangle {
                    x: soundSlider.leftPadding + soundSlider.visualPosition * (soundSlider.availableWidth - width)
                    y: soundSlider.topPadding + soundSlider.availableHeight / 2 - height / 2
                    implicitWidth: 16
                    implicitHeight: 16
                    radius: 8
                    color: soundSlider.pressed ? Theme.background : Theme.primary
                    border.color: Theme.primary
                    border.width: 1
                }
            }
        }

        // --- MICROPHONE ---
        RowLayout {
            Layout.fillWidth: true
            visible: root.expanded
            spacing: 15

            Image {
                source: root.micMuted ? "../shared/icons/mic-muted.svg" : "../shared/icons/mic.svg"
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                sourceSize.width: 20
                sourceSize.height: 20
                fillMode: Image.PreserveAspectFit
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: Theme.primary
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Quickshell.execDetached(["bash", "-c", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"])
                        micStatusProc.running = true
                    }
                }
            }

            Slider {
                id: micSlider
                Layout.fillWidth: true
                from: 0
                to: 100
                value: 50

                onMoved: {
                    Quickshell.execDetached(["bash", "-c", "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ " + Math.round(value) + "%"])
                }

                background: Rectangle {
                    x: micSlider.leftPadding
                    y: micSlider.topPadding + micSlider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 6
                    width: micSlider.availableWidth
                    height: implicitHeight
                    radius: 3
                    color: Theme.background
                    border.color: Theme.primary
                    border.width: 1

                    Rectangle {
                        width: micSlider.visualPosition * parent.width
                        height: parent.height
                        color: Theme.primary
                        radius: 3
                    }
                }

                handle: Rectangle {
                    x: micSlider.leftPadding + micSlider.visualPosition * (micSlider.availableWidth - width)
                    y: micSlider.topPadding + micSlider.availableHeight / 2 - height / 2
                    implicitWidth: 16
                    implicitHeight: 16
                    radius: 8
                    color: micSlider.pressed ? Theme.background : Theme.primary
                    border.color: Theme.primary
                    border.width: 1
                }
            }
        }
    }
}