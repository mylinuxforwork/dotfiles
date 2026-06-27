import QtQuick
import QtQuick.Effects
import qs.CustomTheme

// Reusable round icon button used across the status bar modules.
Rectangle {
    id: btn
    property string iconSrc: ""
    property bool colorize: true
    // Set by the keyboard navigation in StatusbarWindow to highlight the
    // currently selected module.
    property bool focused: false
    signal clicked()

    // Run the button's action (mouse click or keyboard Return).
    function activate(): void { btn.clicked() }

    // Highlighted when hovered with the mouse or selected via the keyboard.
    readonly property bool active: mouseArea.containsMouse || btn.focused

    implicitWidth: 30
    implicitHeight: 30
    radius: 15

    color: btn.colorize
        ? (btn.active ? Theme.primary : "transparent")
        : (btn.active ? Theme.surface_container_high : "transparent")

    Image {
        anchors.centerIn: parent
        source: btn.iconSrc
        width: 18
        height: 18
        sourceSize.width: 18
        sourceSize.height: 18
        fillMode: Image.PreserveAspectFit
        layer.enabled: btn.colorize
        layer.effect: MultiEffect {
            colorization: 1.0
            colorizationColor: btn.active ? Theme.background : Theme.primary
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: btn.clicked()
    }
}
