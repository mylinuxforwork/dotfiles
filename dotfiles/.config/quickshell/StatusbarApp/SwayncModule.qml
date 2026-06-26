import Quickshell
import QtQuick

// Toggles the SwayNotificationCenter panel.
BarButton {
    iconSrc: "../shared/icons/bell.svg"
    onClicked: {
        Quickshell.execDetached(["swaync-client", "-t", "-sw"])
    }
}
