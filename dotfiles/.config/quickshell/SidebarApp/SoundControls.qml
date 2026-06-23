import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.CustomTheme

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: 20

    property bool isOpen: false
    property var soundIds: []

    Process {
        id: soundOutputs
        command: ["bash", "-c", "pactl list sinks short | awk '{print $1}'"]

        running: root.isOpen

        stdout: StdioCollector {
            onStreamFinished: {
                root.soundIds = this.text.trim().split("\n").map(id => parseInt(id)).filter(id => !isNaN(id));
                console.log("Sinks:", root.soundIds);
            }
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 20

        Text {
            text: "Sound"
            color: Theme.primary
            font.family: "monospace"
            font.pixelSize: 18
        }

        Repeater {
            model: root.soundIds

            delegate: RowLayout {
                Layout.fillWidth: true
                spacing: 15

                property int sinkId: modelData

                Text {
                    text: " " //+ sinkId
                    color: Theme.primary
                    font.family: "monospace"
                    font.pixelSize: 18
                }

                Slider {
                    id: soundSlider
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: 50

                    Process {
                        command: ["bash", "-c", "pactl get-sink-volume " + sinkId + " | grep -o '[0-9]*%' | head -1 | sed 's/%//'"]
                        running: root.isOpen
                        stdout: StdioCollector {
                            onStreamFinished: {
                                let v = parseInt(this.text.trim());
                                if (!isNaN(v))
                                    soundSlider.value = v;
                            }
                        }
                    }

                    onMoved: {
                        Quickshell.execDetached(["bash", "-c", "pactl set-sink-volume " + sinkId + " " + Math.round(value) + "%"]);
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
        }
    }
}
