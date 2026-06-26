import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

// System tray (StatusNotifierItem hosts).
RowLayout {
    spacing: 10

    Repeater {
        model: SystemTray.items

        delegate: MouseArea {
            id: trayItem
            required property var modelData

            implicitWidth: 20
            implicitHeight: 20
            Layout.alignment: Qt.AlignVCenter
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            Image {
                anchors.centerIn: parent
                source: trayItem.modelData.icon
                width: 18
                height: 18
                sourceSize.width: 18
                sourceSize.height: 18
                fillMode: Image.PreserveAspectFit
            }

            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton && !modelData.onlyMenu) {
                    modelData.activate()
                } else if (modelData.hasMenu) {
                    trayMenu.open()
                }
            }

            QsMenuAnchor {
                id: trayMenu
                menu: trayItem.modelData.menu
                anchor.item: trayItem
                anchor.edges: Edges.Bottom
                anchor.gravity: Edges.Bottom
            }
        }
    }
}
