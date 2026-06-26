import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.CustomTheme

// Hyprland workspace switcher.
RowLayout {
    spacing: 6

    Repeater {
        model: Hyprland.workspaces

        delegate: Rectangle {
            id: ws
            required property var modelData

            implicitWidth: 26
            implicitHeight: 26
            radius: 13

            color: modelData.focused
                ? Theme.primary
                : (wsMouse.containsMouse ? Theme.surface_container_high : "transparent")
            border.color: Theme.primary
            border.width: modelData.focused ? 0 : 1

            Text {
                anchors.centerIn: parent
                text: ws.modelData.id
                color: ws.modelData.focused ? Theme.background : Theme.on_background
                font.family: Theme.fontFamily
                font.pixelSize: 13
                font.bold: true
            }

            MouseArea {
                id: wsMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: ws.modelData.activate()
            }
        }
    }
}
