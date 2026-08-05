import QtQuick
import qs.CustomTheme

// Small themed context menu shown above a dock item on right click.
//
// This is a plain Item living inside the dock's own window, not a PopupWindow:
// while the dock holds a Hyprland focus grab (which is what closes the menu on
// an outside click), pointer input only reaches the grabbed layer surface, so a
// separate popup surface renders but never receives the clicks on its entries.
// DockWindow grows its window and widens its input mask to make room for it.
//
// The entries are handed in as a list of
//   { "label": "Pin to Dock", "callback": function () { ... } }
// objects; running a callback closes the menu.
Item {
    id: menu

    property var actions: []
    // Fixed width: sizing the menu to its longest label would make the rows'
    // width depend on the background, whose width depends on the rows — a
    // layout polish loop. The entries are short and known, so a constant is
    // enough (labels elide if a future one is longer).
    property int menuWidth: 200

    signal closeRequested()

    implicitWidth: menu.menuWidth
    implicitHeight: menuColumn.implicitHeight + 16
    width: implicitWidth
    height: implicitHeight
    visible: false

    Rectangle {
        id: menuBg
        anchors.fill: parent
        // Same card style as the sidebar's context menus: flat background with
        // a thin accent border.
        radius: 8
        color: Theme.background
        border.width: 1
        border.color: Theme.primary

        Column {
            id: menuColumn
            anchors.centerIn: parent
            width: parent.width - 16
            spacing: 2

            Repeater {
                model: menu.actions

                delegate: Rectangle {
                    id: row
                    required property var modelData

                    width: menuColumn.width
                    height: 36
                    radius: 4
                    color: rowMouse.containsMouse ? Theme.primary : "transparent"

                    Behavior on color {
                        ColorAnimation { duration: 200; easing.type: Easing.OutQuint }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        text: row.modelData.label
                        color: rowMouse.containsMouse ? Theme.background : Theme.primary
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        elide: Text.ElideRight
                        width: parent.width - 20

                        Behavior on color {
                            ColorAnimation { duration: 200; easing.type: Easing.OutQuint }
                        }
                    }

                    MouseArea {
                        id: rowMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            // Grab the callback before closing: closing clears
                            // the model and tears this delegate down, so reading
                            // modelData afterwards is not safe. The action runs
                            // after the menu is gone, since it may rebuild the
                            // dock items underneath it.
                            const run = row.modelData.callback
                            menu.closeRequested()
                            Qt.callLater(run)
                        }
                    }
                }
            }
        }
    }
}
