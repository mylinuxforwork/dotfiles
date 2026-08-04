import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects
import qs.CustomTheme

// One app in the dock: its icon, a running/focused indicator, a tooltip with
// the app name and a right-click menu to pin or unpin it.
Item {
    id: item

    // { key, appId, desktopEntry, name, iconSource, windows, pinned } — built by
    // DockWindow, which owns the desktop-entry lookup.
    property var entry: null
    property int iconSize: 32
    // The dock window. It owns the (single) context menu, which is drawn inside
    // its own surface — see DockMenu for why it is not a popup window.
    property var dockWindow: null

    // Whether the open context menu belongs to this item.
    readonly property bool menuOpen: item.dockWindow
        && item.dockWindow.menuItem === item

    signal pinRequested(string key)
    signal unpinRequested(string key)

    readonly property var windows: item.entry ? item.entry.windows : []
    readonly property bool running: item.windows.length > 0
    readonly property bool pinned: item.entry ? item.entry.pinned : false
    readonly property var desktopEntry: item.entry ? item.entry.desktopEntry : null
    readonly property string appName: item.entry ? item.entry.name : ""
    readonly property string iconSource: item.entry ? item.entry.iconSource : ""

    // Whether one of this app's windows is the focused one.
    readonly property bool active: {
        const focused = ToplevelManager.activeToplevel
        if (!focused)
            return false
        for (let i = 0; i < item.windows.length; i++)
            if (item.windows[i] === focused)
                return true
        return false
    }

    readonly property bool highlighted: itemMouse.containsMouse || item.menuOpen

    implicitWidth: item.iconSize + 16
    implicitHeight: item.iconSize + 18

    // --- ACTIONS ---
    function launch(): void {
        if (item.desktopEntry) {
            item.desktopEntry.execute()
            return
        }
        // No desktop entry (e.g. a pinned id inherited from nwg-dock whose app
        // ships none): run the id as a command, which is what that id is.
        if (item.entry && item.entry.appId)
            Quickshell.execDetached(["bash", "-c", item.entry.appId])
    }

    // Focus the app: its only window, or — when it has several — the one after
    // the currently focused one, so repeated clicks cycle through them.
    function activate(): void {
        if (!item.running) {
            item.launch()
            return
        }
        if (item.windows.length === 1) {
            item.windows[0].activate()
            return
        }
        let index = -1
        const focused = ToplevelManager.activeToplevel
        for (let i = 0; i < item.windows.length; i++)
            if (item.windows[i] === focused)
                index = i
        item.windows[(index + 1) % item.windows.length].activate()
    }

    function closeWindows(): void {
        // Copy first: closing mutates the toplevel list this array comes from.
        const list = item.windows.slice()
        for (let i = 0; i < list.length; i++)
            list[i].close()
    }

    // Entries for the right-click menu, rebuilt each time it opens.
    function menuActions(): var {
        let actions = []
        if (item.pinned)
            actions.push({ "label": "Unpin from Dock",
                           "callback": () => item.unpinRequested(item.entry.key) })
        else
            actions.push({ "label": "Pin to Dock",
                           "callback": () => item.pinRequested(item.entry.key) })
        actions.push({ "label": item.running ? "New Window" : "Launch",
                       "callback": () => item.launch() })
        if (item.running)
            actions.push({ "label": item.windows.length > 1
                               ? "Close All Windows" : "Close Window",
                           "callback": () => item.closeWindows() })
        return actions
    }

    // --- ICON ---
    // Accent circle behind the icon on hover, matching the status bar buttons.
    Rectangle {
        id: hoverBg
        anchors.centerIn: iconImage
        width: item.iconSize + 14
        height: item.iconSize + 14
        radius: width / 2
        color: item.highlighted ? Theme.primary : "transparent"
        opacity: item.highlighted ? 0.25 : 0

        Behavior on color {
            ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
        }
        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.OutQuint }
        }
    }

    Image {
        id: iconImage
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 4
        source: item.iconSource
        width: item.iconSize
        height: item.iconSize
        sourceSize.width: item.iconSize * 2
        sourceSize.height: item.iconSize * 2
        fillMode: Image.PreserveAspectFit
        // Pinned apps that are not running are dimmed, like in nwg-dock.
        opacity: item.running ? 1 : 0.55
        scale: item.highlighted ? 1.12 : 1

        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.OutQuint }
        }
        Behavior on scale {
            NumberAnimation { duration: 300; easing.type: Easing.OutQuint }
        }
    }

    // --- RUNNING INDICATOR ---
    // A dot below the icon for a running app; it widens into a short bar while
    // one of its windows has focus.
    Rectangle {
        id: indicator
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        height: 4
        width: item.active ? 14 : 4
        radius: 2
        color: Theme.primary
        opacity: item.running ? 1 : 0

        Behavior on width {
            NumberAnimation { duration: 350; easing.type: Easing.OutQuint }
        }
        Behavior on opacity {
            NumberAnimation { duration: 300; easing.type: Easing.OutQuint }
        }
    }

    MouseArea {
        id: itemMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                item.activate()
            } else if (mouse.button === Qt.MiddleButton) {
                item.launch()
            } else if (mouse.button === Qt.RightButton) {
                if (!item.dockWindow)
                    return
                // A second right click on the same icon closes the menu again.
                if (item.menuOpen) {
                    item.dockWindow.closeMenu()
                    return
                }
                tooltipTimer.stop()
                tooltip.visible = false
                item.dockWindow.openMenuFor(item, item.menuActions())
            }
        }

        onEntered: tooltipTimer.restart()
        onExited: {
            tooltipTimer.stop()
            tooltip.visible = false
        }
    }

    // --- TOOLTIP ---
    Timer {
        id: tooltipTimer
        interval: 400
        onTriggered: {
            if (itemMouse.containsMouse && !item.menuOpen)
                tooltip.visible = true
        }
    }

    PopupWindow {
        id: tooltip

        color: "transparent"
        implicitWidth: tooltipBg.implicitWidth
        implicitHeight: tooltipBg.implicitHeight

        // A partial anchor.rect collapses the anchor rectangle and the popup
        // never shows — the gap has to come from margins (see DockMenu).
        anchor.item: item
        anchor.edges: Edges.Top
        anchor.gravity: Edges.Top
        anchor.margins.bottom: 6

        Rectangle {
            id: tooltipBg
            anchors.centerIn: parent
            implicitWidth: tooltipText.implicitWidth + 20
            implicitHeight: tooltipText.implicitHeight + 12
            radius: 8
            color: Theme.surface_container_high
            border.width: 1
            border.color: Theme.outline_variant

            Text {
                id: tooltipText
                anchors.centerIn: parent
                text: item.windows.length > 1
                    ? item.appName + " (" + item.windows.length + ")"
                    : item.appName
                color: Theme.on_surface
                font.family: Theme.fontFamily
                font.pixelSize: 14
            }
        }
    }

}
