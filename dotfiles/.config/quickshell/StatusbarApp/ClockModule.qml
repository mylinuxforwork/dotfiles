import Quickshell
import QtQuick
import qs.CustomTheme

// Time, with the date hanging below it when expanded.
Item {
    id: clockRoot

    // Set by the parent: when true the date is revealed and the time shifts up.
    property bool expanded: false

    implicitWidth: Math.max(timeText.implicitWidth, dateText.implicitWidth)
    implicitHeight: timeText.implicitHeight

    // Live clock, only ticks once per minute.
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
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
        text: Qt.formatDateTime(clock.date, "HH:mm")
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
        text: Qt.formatDateTime(clock.date, "ddd, dd MMM")
        color: Theme.primary
        font.family: Theme.fontFamily
        font.pixelSize: 11

        opacity: clockRoot.expanded ? 1 : 0
        Behavior on opacity {
            NumberAnimation { duration: 250; easing.type: Easing.OutQuint }
        }
    }
}
