import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import qs.CustomTheme

// Clickable section title with a chevron that collapses/expands the section.
// The owner binds its content's `visible` to `expanded`.
Item {
    id: root

    property string title: ""
    property bool expanded: true

    Layout.fillWidth: true
    implicitHeight: row.implicitHeight

    RowLayout {
        id: row
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 10

        Text {
            text: root.title
            color: Theme.primary
            font.family: "Fira Sans"
            font.weight: Font.DemiBold
            font.pixelSize: 18
            Layout.alignment: Qt.AlignVCenter
        }

        Item { Layout.fillWidth: true }

        Image {
            source: "../shared/icons/chevron-right.svg"
            Layout.alignment: Qt.AlignVCenter
            Layout.preferredWidth: 18
            Layout.preferredHeight: 18
            Layout.rightMargin: 6
            sourceSize.width: 18
            sourceSize.height: 18
            fillMode: Image.PreserveAspectFit
            rotation: root.expanded ? 90 : 0
            Behavior on rotation { NumberAnimation { duration: 150 } }
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: Theme.primary
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.expanded = !root.expanded
    }
}
