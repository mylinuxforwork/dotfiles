import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

// System tray (StatusNotifierItem hosts).
RowLayout {
    id: tray
    spacing: 10

    // Collapse the slot when there are no tray items, so the right Repeater
    // hides this Loader and the RowLayout doesn't reserve spacing around an
    // empty, zero-width module (which otherwise leaves a doubled gap next to
    // its neighbours).
    readonly property bool collapsed: SystemTray.items.values.length === 0

    // True while any tray context menu is open. The bar pins itself expanded
    // while this is set: the tray lives in the right area, which is only
    // visible/enabled when the pill is expanded, so without this the popup's
    // anchor item would vanish (pointer leaves the bar -> hover lost ->
    // collapse) and the menu would be dismissed the instant it opened.
    property int openMenuCount: 0
    readonly property bool menuOpen: openMenuCount > 0

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

                // Keep the bar expanded for as long as the menu is open so the
                // anchor item (and this popup) survive the pointer leaving the
                // bar surface.
                onOpened: tray.openMenuCount++
                onClosed: tray.openMenuCount--
            }
        }
    }
}
