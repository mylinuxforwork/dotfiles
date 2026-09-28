import Quickshell
import QtQuick

// Power menu -> toggles the ML4W Power Menu (github.com/mylinuxforwork/ml4w-powermenu).
BarButton {
    iconSrc: "../shared/icons/power.svg"
    onClicked: {
        Quickshell.execDetached(["bash", "-c", "ml4w-powermenu toggle"])
    }
}
