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
    property int screenCount: 1
    property var brightnessValues: ({})
    property bool fetchTick: false
    property bool expanded: true

    // Re-read cached values while the panel stays open. The brightness.sh cache
    // (TTL 15s for display values) makes these calls near-instant.
    readonly property int refreshInterval: 5000

    // First fetch the moment the panel opens, then re-poll periodically.
    // Flipping fetchTick preserves the `running` binding instead of breaking
    // it like a direct running = true/false toggle would.
    onIsOpenChanged: {
        if (root.isOpen)
            root.kickFetch();
    }

    Timer {
        interval: root.refreshInterval
        running: root.isOpen
        repeat: true
        onTriggered: root.kickFetch()
    }

    // Make sure the cache daemon is running once so opening the panel stays
    // instant (display/brightness snapshot stays warm in the background).
    Component.onCompleted: {
        Quickshell.execDetached(["bash", "-c",
            "~/.config/hypr/scripts/brightness.sh daemon"]);
    }

    function kickFetch(): void {
        root.fetchTick = false;
        Qt.callLater(() => { root.fetchTick = true; });
    }

    function parseStatus(text: string): void {
        let count = 1;
        let values = {};
        if (text.length > 0) {
            for (let line of text.split("\n")) {
                if (line.startsWith("displays=")) {
                    let c = parseInt(line.slice(9));
                    if (!isNaN(c))
                        count = c;
                } else if (line.startsWith("display")) {
                    let eq = line.indexOf("=");
                    let idx = parseInt(line.slice(7, eq));
                    let val = parseInt(line.slice(eq + 1));
                    if (!isNaN(idx) && !isNaN(val))
                        values[idx] = val;
                }
            }
        }
        root.brightnessValues = values;
        root.screenCount = count;
    }

    Process {
        id: brightnessStatus
        command: ["bash", "-c", "~/.config/hypr/scripts/brightness.sh status"]
        running: root.isOpen && root.fetchTick

        stdout: StdioCollector {
            onStreamFinished: {
                root.parseStatus(this.text.trim());
            }
        }
    }

    SectionHeader {
        title: "Brightness"
        expanded: root.expanded
        onExpandedChanged: root.expanded = expanded
    }

    Repeater {
        model: root.screenCount

        delegate: RowLayout {
            Layout.fillWidth: true
            visible: root.expanded
            spacing: 15

            RowLayout {
                spacing: 6
                Layout.alignment: Qt.AlignVCenter

                Image {
                    source: "../shared/icons/brightness.svg"
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
                }

                Text {
                    text: "" + (index + 1)
                    color: Theme.primary
                    font.family: "monospace"
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignVCenter
                }
            }

            Slider {
                id: brightnessSlider
                Layout.fillWidth: true
                from: 0
                to: 100
                value: 50 // Default

                function applyCached(): void {
                    if (brightnessSlider.pressed)
                        return;
                    let v = root.brightnessValues[index + 1];
                    if (v !== undefined)
                        brightnessSlider.value = v;
                }

                // Show the cached value as soon as the row appears.
                Component.onCompleted: brightnessSlider.applyCached()

                // Keep picking up new snapshots while the panel is open; safe
                // mid-drag because applyCached skips while pressed.
                Timer {
                    interval: 1000
                    running: root.isOpen
                    repeat: true
                    onTriggered: brightnessSlider.applyCached()
                }

                // Reflect the drag immediately so the slider never snaps back,
                // and commit to hardware + cache only on release.
                onMoved: {
                    root.brightnessValues[index + 1] = Math.round(value);
                }
                onPressedChanged: {
                    if (!pressed) {
                        Quickshell.execDetached(["bash", "-c",
                            "~/.config/hypr/scripts/brightness.sh set-display " + (index + 1) + " " + Math.round(value)]);
                    }
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