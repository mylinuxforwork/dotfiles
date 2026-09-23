import Quickshell
import QtQuick
import qs.DockApp

// Launcher button at the left end of the dock: a 3×3 grid of dots. A left click
// opens the application launcher (like the status bar's launcher button), a
// right click opens the dock menu (Reload Dock, Settings, Edit configuration).
// The menu is the dock's shared context menu, so the button sits in the dock's
// row and is passed to DockWindow.openMenuFor() as the item the menu is
// positioned over.
//
// The dots are drawn here rather than loaded from shared/icons, so the dock
// does not depend on files outside DockApp.
Item {
    id: button

    property int iconSize: 32
    // The dock window, which owns the context menu (see DockMenu).
    property var dockWindow: null

    signal reloadRequested()
    signal settingsRequested()
    signal editConfigRequested()

    // Whether the open context menu belongs to this button.
    readonly property bool menuOpen: button.dockWindow
        && button.dockWindow.menuItem === button

    readonly property bool highlighted: buttonMouse.containsMouse || button.menuOpen

    // Same footprint as an app icon (see DockItem).
    implicitWidth: button.iconSize + 16
    implicitHeight: button.iconSize + 18

    function launch(): void {
        Quickshell.execDetached(["bash", "-c",
            Quickshell.env("HOME") + "/.config/hypr/scripts/launcher.sh"])
    }

    function menuActions(): var {
        return [
            { "label": "Reload Dock", "callback": () => button.reloadRequested() },
            { "label": "Settings", "callback": () => button.settingsRequested() },
            { "label": "Edit configuration",
              "callback": () => button.editConfigRequested() }
        ]
    }

    // Accent circle behind the grid on hover, matching the app icons.
    Rectangle {
        anchors.centerIn: grid
        width: button.iconSize + 14
        height: button.iconSize + 14
        radius: width / 2
        color: DockTheme.primary
        opacity: button.highlighted ? 0.25 : 0

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.OutQuint }
        }
    }

    Grid {
        id: grid
        anchors.centerIn: parent
        // Same lift as the app icons (see DockItem), so the grid lines up with them.
        anchors.verticalCenterOffset: -2
        columns: 3
        spacing: Math.max(3, Math.round(button.iconSize / 8))
        scale: button.highlighted ? 1.12 : 1

        Behavior on scale {
            NumberAnimation { duration: 300; easing.type: Easing.OutQuint }
        }

        Repeater {
            model: 9
            delegate: Rectangle {
                width: Math.max(4, Math.round(button.iconSize / 7))
                height: width
                radius: width / 2
                color: DockTheme.primary
            }
        }
    }

    MouseArea {
        id: buttonMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                if (button.menuOpen)
                    button.dockWindow.closeMenu()
                button.launch()
                return
            }
            if (!button.dockWindow)
                return
            // A second right click closes the menu again.
            if (button.menuOpen) {
                button.dockWindow.closeMenu()
                return
            }
            button.dockWindow.openMenuFor(button, button.menuActions())
        }
    }
}
