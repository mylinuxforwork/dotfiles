import Quickshell
import QtQuick

// ML4W logo -> toggles the Sidebar app via IPC.
BarButton {
    iconSrc: Quickshell.env("HOME") + "/.config/ml4w/assets/ml4w.svg"
    colorize: false
    onClicked: {
        Quickshell.execDetached(["qs", "ipc", "call", "sidebar", "toggle"])
    }
}
