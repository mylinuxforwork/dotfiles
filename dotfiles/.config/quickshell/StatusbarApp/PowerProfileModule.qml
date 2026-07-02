import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.CustomTheme

// Shows the active system power profile as an icon (leaf / gauge / rocket) and
// opens a small popup menu to switch between power-saver, balanced and
// performance. Reads and writes through Quickshell's PowerProfiles service,
// which is backed by power-profiles-daemon; no shell-out is needed. The module
// is always visible (unlike the battery module) so the profile can be changed
// both on battery and while plugged in.
Rectangle {
    id: profileRoot

    // Current profile as reported by power-profiles-daemon.
    readonly property int current: PowerProfiles.profile
    // Whether the daemon offers a performance profile (some machines don't).
    readonly property bool hasPerformance: PowerProfiles.hasPerformanceProfile

    // Whether the switch popup is open.
    property bool menuOpen: false
    // Set by the keyboard navigation in StatusbarWindow.
    property bool focused: false

    // The three selectable profiles, in ascending-power order. Performance is
    // dropped when the daemon does not expose it.
    readonly property var profiles: {
        let list = [
            { "value": PowerProfile.PowerSaver,  "label": "Power Saver",  "icon": "../shared/icons/profile-power-saver.svg" },
            { "value": PowerProfile.Balanced,    "label": "Balanced",     "icon": "../shared/icons/profile-balanced.svg" }
        ]
        if (hasPerformance)
            list.push({ "value": PowerProfile.Performance, "label": "Performance", "icon": "../shared/icons/profile-performance.svg" })
        return list
    }

    // Icon for the currently active profile, shown in the bar.
    readonly property string iconSource: {
        switch (current) {
        case PowerProfile.PowerSaver:   return "../shared/icons/profile-power-saver.svg"
        case PowerProfile.Performance:  return "../shared/icons/profile-performance.svg"
        default:                        return "../shared/icons/profile-balanced.svg"
        }
    }

    // Apply a profile and close the menu.
    function setProfile(value: int): void {
        PowerProfiles.profile = value
        profileRoot.menuOpen = false
    }

    // Mouse click / keyboard Return: toggle the switch popup.
    function activate(): void {
        profileRoot.menuOpen = !profileRoot.menuOpen
    }

    readonly property bool active: mouseArea.containsMouse || profileRoot.focused || profileRoot.menuOpen

    implicitWidth: 30
    implicitHeight: 30
    radius: 15

    // Same accent-filled circle as BarButton on hover/selection/open.
    color: active ? Theme.primary : "transparent"
    Behavior on color {
        ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
    }

    Image {
        anchors.centerIn: parent
        source: profileRoot.iconSource
        width: 18
        height: 18
        sourceSize.width: 18
        sourceSize.height: 18
        fillMode: Image.PreserveAspectFit
        layer.enabled: true
        layer.effect: MultiEffect {
            colorization: 1.0
            colorizationColor: profileRoot.active ? Theme.background : Theme.primary
            Behavior on colorizationColor {
                ColorAnimation { duration: 500; easing.type: Easing.OutQuint }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: profileRoot.activate()
    }

    // ==========================================
    // SWITCH POPUP
    // ==========================================
    // Anchored just below the icon. grabFocus lets a click outside dismiss it.
    PopupWindow {
        id: popup
        anchor.item: profileRoot
        anchor.edges: Edges.Bottom
        anchor.gravity: Edges.Bottom
        anchor.margins.top: 10
        // Center the popup under the icon.
        anchor.rect.x: profileRoot.width / 2 - popup.width / 2

        visible: profileRoot.menuOpen

        // Grab input while open so a click anywhere outside the popup dismisses
        // it — the same primitive the status bar itself uses.
        HyprlandFocusGrab {
            windows: [popup]
            active: profileRoot.menuOpen
            onCleared: profileRoot.menuOpen = false
        }

        implicitWidth: 190
        implicitHeight: menuColumn.implicitHeight + 16
        color: "transparent"

        // Take keyboard focus while open so Escape closes the menu (the popup
        // is opened via keyboard Return as well as by mouse). forceActiveFocus
        // on show because the popup surface is only created once visible.
        FocusScope {
            id: keyScope
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: profileRoot.menuOpen = false
        }

        onVisibleChanged: {
            if (visible)
                keyScope.forceActiveFocus()
        }

        // Card background with the same gradient border as the pill.
        Rectangle {
            anchors.fill: parent
            radius: 12
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Theme.primary }
                GradientStop { position: 1.0; color: Theme.on_primary }
            }
            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                radius: parent.radius - anchors.margins
                color: Theme.background
            }
        }

        ColumnLayout {
            id: menuColumn
            anchors.fill: parent
            anchors.margins: 8
            spacing: 2

            Repeater {
                model: profileRoot.profiles
                delegate: Rectangle {
                    required property var modelData
                    readonly property bool selected: modelData.value === profileRoot.current
                    Layout.fillWidth: true
                    implicitHeight: 34
                    radius: 8
                    color: rowMouse.containsMouse || selected ? Theme.primary : "transparent"
                    Behavior on color {
                        ColorAnimation { duration: 200; easing.type: Easing.OutQuint }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 10
                        spacing: 8

                        Image {
                            Layout.alignment: Qt.AlignVCenter
                            source: modelData.icon
                            width: 16
                            height: 16
                            sourceSize.width: 16
                            sourceSize.height: 16
                            fillMode: Image.PreserveAspectFit
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: (rowMouse.containsMouse || selected) ? Theme.background : Theme.primary
                            }
                        }

                        Text {
                            Layout.alignment: Qt.AlignVCenter
                            Layout.fillWidth: true
                            text: modelData.label
                            color: (rowMouse.containsMouse || selected) ? Theme.background : Theme.primary
                            font.family: Theme.fontFamily
                            font.pixelSize: 13
                            font.bold: selected
                        }
                    }

                    MouseArea {
                        id: rowMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: profileRoot.setProfile(modelData.value)
                    }
                }
            }
        }
    }
}
