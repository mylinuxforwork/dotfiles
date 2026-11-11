import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.CustomTheme

// Shows the number of entries in the clipboard history next to a clipboard
// icon; clicking it opens the ML4W clipboard manager (ml4w-cliphist, the same
// script as SUPER + V and the Waybar module), which is walker or rofi
// depending on the selected launcher.
//
// The count is refreshed right after every clipboard change (wl-paste --watch)
// and additionally polled, because deleting entries or wiping the history in
// the clipboard manager does not touch the clipboard itself.
Rectangle {
    id: clipboard

    // Number of entries in the clipboard history of the launcher in use.
    property int count: 0
    // Set by the keyboard navigation in StatusbarWindow.
    property bool focused: false

    // Run the module's action (mouse click or keyboard Return).
    function activate(): void {
        Quickshell.execDetached(["bash", "-c",
            Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-cliphist"])
    }

    function refresh(): void {
        countProc.running = false
        countProc.running = true
    }

    readonly property bool active: mouseArea.containsMouse || clipboard.focused

    // Tight 3px padding each side, like the updates module.
    implicitWidth: row.implicitWidth + 6
    implicitHeight: 30
    radius: 15

    // Same accent-filled highlight as BarButton on hover/selection.
    color: active ? Theme.primary : "transparent"

    Behavior on color {
        ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
    }

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Image {
            Layout.alignment: Qt.AlignVCenter
            source: "../shared/icons/clipboard.svg"
            sourceSize.width: 18
            sourceSize.height: 18
            width: 18
            height: 18
            fillMode: Image.PreserveAspectFit
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: clipboard.active ? Theme.background : Theme.primary
                Behavior on colorizationColor {
                    ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            text: clipboard.count
            color: clipboard.active ? Theme.background : Theme.primary
            font.family: Theme.fontFamily
            font.pixelSize: 14
            font.bold: true
            Behavior on color {
                ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: clipboard.activate()
    }

    // Count the history entries of the launcher in use: walker keeps its
    // history in elephant (one JSON line per item), rofi uses cliphist (one
    // line per item). The launcher is resolved on every count, so switching it
    // in the settings is picked up without a reload.
    Process {
        id: countProc
        command: ["bash", "-c",
            "if [ \"$(\"$HOME\"/.config/ml4w/scripts/ml4w-launcher which)\" = walker ]; then "
            + "timeout 3 elephant query --json 'clipboard;;100000' 2>/dev/null | grep -c '\"identifier\"'; "
            + "else cliphist list 2>/dev/null | wc -l; fi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: clipboard.count = parseInt(this.text.trim()) || 0
        }
    }

    // Prints a line on every clipboard change. The recount is delayed a moment
    // so elephant (walker) or the `wl-paste --watch cliphist store` from
    // autostart (rofi) has stored the new entry first.
    Process {
        id: watchProc
        command: ["wl-paste", "--watch", "echo", "changed"]
        running: true
        stdout: SplitParser {
            onRead: _ => recountDelay.restart()
        }
    }

    Timer {
        id: recountDelay
        interval: 300
        onTriggered: clipboard.refresh()
    }

    // Picks up deletions/wipes made in the clipboard manager.
    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: clipboard.refresh()
    }

    // `qs ipc call clipboard refresh` recounts on demand.
    IpcHandler {
        target: "clipboard"
        function refresh(): void { clipboard.refresh() }
    }
}
