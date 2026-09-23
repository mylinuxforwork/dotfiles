import QtQuick
import QtQuick.Controls
import qs.DockApp

// Themed on/off switch for the dock settings dialog. Same look as the
// sidebar's ML4WSwitch, kept as a copy here so the dock does not depend on the
// sidebar.
//
// It shows `value` and reports clicks through toggledTo() instead of owning its
// state: a Switch sets `checked` itself on click, which would break a plain
// `checked: <setting>` binding and stop the switch following changes made
// elsewhere (IPC, the config file). The binding is restored after every click.
Switch {
    id: control

    property bool value: false

    signal toggledTo(bool on)

    checked: control.value
    onToggled: {
        control.toggledTo(control.checked)
        control.checked = Qt.binding(() => control.value)
    }

    implicitWidth: 48
    implicitHeight: 26

    indicator: Rectangle {
        implicitWidth: 48
        implicitHeight: 26
        radius: 13
        color: control.checked ? DockTheme.primary : DockTheme.background
        border.color: DockTheme.primary
        border.width: 1

        Rectangle {
            x: control.checked ? parent.width - width - 2 : 2
            y: 2
            implicitWidth: 22
            implicitHeight: 22
            radius: 11
            color: control.checked ? DockTheme.background : DockTheme.on_primary
            Behavior on x { NumberAnimation { duration: 150 } }
        }
    }
}
