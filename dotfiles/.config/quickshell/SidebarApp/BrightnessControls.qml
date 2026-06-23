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
                text: "☀ "
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

                Timer {
                    id: brightnessTimer
                    interval: 50 // play with the delay if you want to make it more or less responsive, keep in mind that DDC/CI commands can be slow and you don't want to spam them too much
                    repeat: false

                    onTriggered: {
                        Quickshell.execDetached(["bash", "-c", "~/.config/hypr/scripts/brightness.sh set-display " + (index + 1) + " " + Math.round(brightnessSlider.value)]);
                    }
                }

                onMoved: {
                    brightnessTimer.restart();
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
