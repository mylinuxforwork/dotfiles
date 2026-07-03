import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.CustomTheme

// Shows the battery charge percentage next to a battery icon. The module is
// shown only on machines that actually have a laptop battery, so on a desktop
// it never appears. While the module is visible it stays up whether running on
// battery or plugged in: the icon shows the charge level on battery and switches
// to a charging icon whenever a power adapter is connected. The data comes from
// the UPower service's display device.
Rectangle {
    id: battery

    // The aggregate battery UPower exposes for the whole machine.
    readonly property var device: UPower.displayDevice
    // True when this machine has a real, present laptop battery. This is the
    // sole condition for showing the module (a desktop reports none).
    readonly property bool hasBattery: device !== null
        && device.isLaptopBattery && device.isPresent
    // True while a power adapter is connected (the system is NOT draining the
    // battery). Drives the charging icon.
    readonly property bool pluggedIn: !UPower.onBattery
    // Rounded charge percentage (0–100). UPower's percentage is a 0.0–1.0
    // fraction, so scale it up before rounding.
    readonly property int percent: device ? Math.round(device.percentage * 100) : 0

    // Preview switch: while true the module is shown with a demo charge so the
    // layout can be reviewed on a machine that has no battery (a desktop).
    // Set to false for the final implementation.
    property bool preview: false

    // Shown whenever a laptop battery exists. In preview mode it is always shown.
    readonly property bool collapsed: !preview && !hasBattery
    readonly property int shownPercent: preview && !hasBattery ? 72 : percent
    readonly property bool shownCharging: preview && !hasBattery ? false : pluggedIn

    // Read-only indicator: no click action, so it is not part of the keyboard
    // navigation (rebuildNavItems only picks up modules exposing activate()).

    // Pick the icon from the charging state and charge level.
    readonly property string iconSource: {
        if (shownCharging)
            return "../shared/icons/battery-charging.svg"
        if (shownPercent <= 33)
            return "../shared/icons/battery-low.svg"
        if (shownPercent <= 66)
            return "../shared/icons/battery-medium.svg"
        return "../shared/icons/battery-full.svg"
    }

    visible: !collapsed

    // Read-only indicator: never highlighted (no hover/selection state), so the
    // icon and text always use the accent color and the background stays clear.
    readonly property bool active: false

    implicitWidth: collapsed ? 0 : row.implicitWidth + 6
    implicitHeight: 30
    radius: 15
    color: "transparent"

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Image {
            Layout.alignment: Qt.AlignVCenter
            source: battery.iconSource
            sourceSize.width: 18
            sourceSize.height: 18
            width: 18
            height: 18
            fillMode: Image.PreserveAspectFit
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: battery.active ? Theme.background : Theme.primary
                Behavior on colorizationColor {
                    ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignVCenter
            text: battery.shownPercent + "%"
            color: battery.active ? Theme.background : Theme.primary
            font.family: Theme.fontFamily
            font.pixelSize: 14
            font.bold: true
            Behavior on color {
                ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
            }
        }
    }
}
