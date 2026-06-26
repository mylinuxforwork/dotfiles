import Quickshell
import QtQuick

// Power menu -> toggles the Power app via IPC.
BarButton {
    iconSrc: "../shared/icons/power.svg"
    onClicked: {
        Quickshell.execDetached(["qs", "ipc", "call", "power", "toggle"])
    }
}
