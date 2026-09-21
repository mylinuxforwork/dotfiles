import Quickshell
import QtQuick
import qs.CustomTheme

// Time, with the date hanging below it when expanded.
Item {
    id: clockRoot

    // Set by the parent: when true the date is revealed and the time shifts up.
    property bool expanded: false
    // Qt date/time format for the time, supplied from config.json.
    property string timeFormat: "HH:mm"
    // Qt date/time format for the date shown below the time when expanded.
    property string dateFormat: "ddd, dd MMM"
    // Optional shell command for an external calendar app (e.g. "gnome-calendar"),
    // supplied from config.json. When set, a right click launches it; when empty
    // the right click does nothing.
    property string calendarCommand: ""
    // Set by the keyboard navigation in StatusbarWindow.
    property bool focused: false

    // Asks the window to show/hide the calendar panel. A signal rather than a
    // direct call so the module stays independent of where the panel lives;
    // StatusbarWindow connects it when it places the module.
    signal calendarToggleRequested()

    // Run the module's action (mouse click or keyboard Return).
    function activate(): void {
        clockRoot.calendarToggleRequested()
    }

    // Launch the external calendar app configured in config.json. Run through
    // bash so the value can carry arguments, like the terminal module does.
    function openExternalCalendar(): void {
        if (clockRoot.calendarCommand === "")
            return
        Quickshell.execDetached(["bash", "-c", clockRoot.calendarCommand])
    }

    implicitWidth: Math.max(timeText.implicitWidth, dateText.implicitWidth)
    implicitHeight: timeText.implicitHeight

    // Nudge the whole module up slightly in expanded mode so the time+date
    // block sits centered alongside the other icons.
    transform: Translate { y: clockRoot.expanded ? -2 : 0 }

    // Highlight ring shown when selected via the keyboard. Wraps tightly around
    // the visible content (the time, plus the date when expanded).
    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: -8
        anchors.rightMargin: -8
        anchors.top: timeText.top
        anchors.topMargin: -4
        anchors.bottom: clockRoot.expanded ? dateText.bottom : timeText.bottom
        anchors.bottomMargin: -4
        radius: 8
        color: "transparent"
        border.color: Theme.primary
        border.width: 1
        opacity: clockRoot.focused ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }

    // Live clock, only ticks once per minute.
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // Left click toggles the Calendar app via IPC, right click opens the
    // external calendar app when one is configured. Covers the time and the
    // date (which hangs below the item's own bounds).
    MouseArea {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: dateText.bottom
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                clockRoot.openExternalCalendar()
            else
                clockRoot.activate()
        }
    }

    Text {
        id: timeText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        // Shift up when expanded so the date below has more room.
        anchors.verticalCenterOffset: clockRoot.expanded ? -6 : 0
        Behavior on anchors.verticalCenterOffset {
            NumberAnimation { duration: 250; easing.type: Easing.OutQuint }
        }
        text: Qt.formatDateTime(clock.date, clockRoot.timeFormat)
        color: Theme.primary
        font.family: Theme.fontFamily
        font.pixelSize: 16
        font.bold: true
    }

    Text {
        id: dateText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: timeText.bottom
        anchors.topMargin: 1
        text: Qt.formatDateTime(clock.date, clockRoot.dateFormat)
        color: Theme.primary
        font.family: Theme.fontFamily
        font.pixelSize: 11

        opacity: clockRoot.expanded ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: 250; easing.type: Easing.OutQuint }
        }
    }
}
