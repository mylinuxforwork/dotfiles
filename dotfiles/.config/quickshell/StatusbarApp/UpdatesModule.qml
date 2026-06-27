import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.CustomTheme

// Shows the number of pending system updates next to a package icon. The count
// comes from ml4w-check-system-updates (the same script the Waybar module
// uses), polled every 30 minutes. The module hides itself completely while no
// updates are available; clicking it launches the ML4W update routine.
Rectangle {
    id: updates

    // Number of available updates (0 = nothing pending, module hidden).
    property int count: 0
    // Set by the keyboard navigation in StatusbarWindow.
    property bool focused: false

    // Run the module's action (mouse click or keyboard Return).
    function activate(): void {
        Quickshell.execDetached(["bash", "-c",
            Quickshell.env("HOME") + "/.config/ml4w/settings/installupdates.sh"])
    }

    // Hidden (and collapsed to zero size) when there is nothing to update. The
    // right Repeater binds its Loader's visibility to this so the layout slot
    // disappears too, and rebuildNavItems skips invisible modules.
    visible: count > 0

    readonly property bool active: mouseArea.containsMouse || updates.focused

    implicitWidth: visible ? row.implicitWidth + 16 : 0
    implicitHeight: 30
    radius: 15

    // Same accent-filled highlight as BarButton on hover/selection.
    color: active ? Theme.primary : "transparent"

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 6

        Image {
            Layout.alignment: Qt.AlignVCenter
            source: "../shared/icons/package.svg"
            sourceSize.width: 18
            sourceSize.height: 18
            width: 18
            height: 18
            fillMode: Image.PreserveAspectFit
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: updates.active ? Theme.background : Theme.primary
            }
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            text: updates.count
            color: updates.active ? Theme.background : Theme.primary
            font.family: Theme.fontFamily
            font.pixelSize: 14
            font.bold: true
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: updates.activate()
    }

    // Parse the script's JSON output ({"text": "69", ...}); an empty line means
    // zero updates and the script prints nothing.
    function refresh(): void {
        updatesProc.running = false
        updatesProc.running = true
    }

    Process {
        id: updatesProc
        command: ["bash", "-c",
            Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-check-system-updates"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let raw = this.text.trim()
                    updates.count = raw ? parseInt(JSON.parse(raw).text) || 0 : 0
                } catch (e) {
                    updates.count = 0
                }
            }
        }
    }

    // Re-check on the same 1800s interval as the Waybar module.
    Timer {
        interval: 1800 * 1000
        running: true
        repeat: true
        onTriggered: updates.refresh()
    }
}
