import QtQuick
import QtQuick.Effects
import qs.CustomTheme

// Reusable round icon button used across the status bar modules.
Rectangle {
    id: btn
    property string iconSrc: ""
    property bool colorize: true
    signal clicked()

    implicitWidth: 30
    implicitHeight: 30
    radius: 15

    color: (mouseArea.containsMouse && btn.colorize) ? Theme.primary : "transparent"

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
            colorizationColor: mouseArea.containsMouse ? Theme.background : Theme.primary
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
