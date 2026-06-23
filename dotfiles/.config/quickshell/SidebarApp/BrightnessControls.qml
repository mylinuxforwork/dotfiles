import Quickshell
import Quickshell.Io
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import qs.CustomTheme

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: 20

    property bool isOpen: false
    property int screenCount: 1

    Process {
        id: brightnessDisplays
        command: ["bash", "-c", "~/.config/hypr/scripts/brightness.sh displays"]

        running: root.isOpen

        stdout: StdioCollector {
            onStreamFinished: {
                root.screenCount = parseInt(this.text.trim());
            }
        }
    }

    Text {
        text: "Brightness" // Sun/Brightness icon
        color: Theme.primary
        font.family: "monospace"
        font.pixelSize: 18
        Layout.alignment: Qt.AlignVCenter
    }

    Repeater {
        model: root.screenCount

        delegate: RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Text {
                text: "☀ " + (index + 1)
                color: Theme.primary
                font.family: "monospace"
                font.pixelSize: 18
                Layout.alignment: Qt.AlignVCenter
            }

            Slider {
                id: brightnessSlider
                Layout.fillWidth: true
                from: 0
                to: 100
                value: 50 // Default

                Process {
                    command: ["bash", "-c", "~/.config/hypr/scripts/brightness.sh get-display " + (index + 1)]
                    running: root.isOpen
                    stdout: StdioCollector {
                        onStreamFinished: {
                            let v = parseInt(this.text.trim());
                            if (!isNaN(v))
                                brightnessSlider.value = v;
                        }
                    }
                }

                onMoved: {
                    Quickshell.execDetached(["bash", "-c", "~/.config/hypr/scripts/brightness.sh set-display " + (index + 1) + " " + Math.round(value)]);
                }

                background: Rectangle {
                    x: brightnessSlider.leftPadding
                    y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                    implicitWidth: 200
                    implicitHeight: 6
                    width: brightnessSlider.availableWidth
                    height: implicitHeight
                    radius: 3
                    color: Theme.background
                    border.color: Theme.primary
                    border.width: 1

                    Rectangle {
                        width: brightnessSlider.visualPosition * parent.width
                        height: parent.height
                        color: Theme.primary
                        radius: 3
                    }
                }

                handle: Rectangle {
                    x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width)
                    y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                    implicitWidth: 16
                    implicitHeight: 16
                    radius: 8
                    color: brightnessSlider.pressed ? Theme.background : Theme.primary
                    border.color: Theme.primary
                    border.width: 1
                }
            }
        }
    }
}
