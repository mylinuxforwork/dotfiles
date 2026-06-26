import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland // <-- Added native Hyprland integration
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import qs.CustomTheme

PanelWindow {
    id: root

    // --- 1. OVERLAY & WAYLAND FIXES ---
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: WlrLayershell.Ignore

    implicitWidth: panelBg.implicitWidth + 40
    implicitHeight: panelBg.implicitHeight + 40
    color: "transparent"

    anchors {
        right: true
    }

    // --- CLICK OUTSIDE TO CLOSE (Native Hyprland) ---
    HyprlandFocusGrab {
        windows: [root]
        active: root.isOpen
        onCleared: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- HANDLE ESCAPE SHORTCUT ---
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- 2. ANIMATION LOGIC (FIXED) ---
    property bool isOpen: false
    property int selectedIndex: -1
    property int buttonCount: 5

    onIsOpenChanged: {
        if (isOpen) {
            selectedIndex = -1
            panelBg.forceActiveFocus()
        }
    }

    function activateSelected() {
        var commands = [
            Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-power -l",
            Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-power -s",
            Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-power -e",
            Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-power -r",
            Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-power -p"
        ]
        if (selectedIndex >= 0 && selectedIndex < commands.length) {
            Quickshell.execDetached(["bash", "-c", commands[selectedIndex]])
            isOpen = false
        }
    }

    // Keep the window mapped to the screen while the animation is playing
    visible: isOpen || slideAnim.running

    margins {
        right: root.currentMargin
    }

    // Ternary operator: If open, set to 20. If closed, set to -150.
    property real currentMargin: isOpen ? 0 : -170

    // This automatically animates currentMargin whenever it changes!
    Behavior on currentMargin {
        NumberAnimation {
            id: slideAnim
            duration: 350
            easing.type: Easing.OutQuint
        }
    }

    IpcHandler {
        target: "power"
        function toggle(): void { root.isOpen = !root.isOpen }
        function open(): void { root.isOpen = true }   // <-- Added for Waybar safety
        function close(): void { root.isOpen = false } // <-- Added for Waybar safety
    }

    Process {
        id: powerProcess
        running: false
    }

    // ==========================================
    // MAIN PANEL BACKGROUND (The Pill Shape)
    // ==========================================
    Item {
        id: panelBg
        implicitWidth: 80
        implicitHeight: buttonLayout.implicitHeight + 40
        anchors.centerIn: parent

        focus: true

        Keys.onUpPressed: {
            if (root.selectedIndex <= 0)
                root.selectedIndex = root.buttonCount - 1
            else
                root.selectedIndex--
        }
        Keys.onDownPressed: {
            if (root.selectedIndex >= root.buttonCount - 1)
                root.selectedIndex = 0
            else
                root.selectedIndex++
        }
        Keys.onReturnPressed: root.activateSelected()
        Keys.onEnterPressed: root.activateSelected()

        RectangularShadow {
            id: shadow
            anchors.fill: mainBgRect
            radius: mainBgRect.radius
            blur: 15
            color: Qt.rgba(Theme.shadow.r, Theme.shadow.g, Theme.shadow.b, 0.4)
        }

        Rectangle {
            id: mainBgRect
            anchors.fill: parent
            radius: 40
            opacity: 0.9 // Only the background is transparent

            // Gradient border (outer)
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Theme.primary }
                GradientStop { position: 1.0; color: Theme.on_primary }
            }

            // Background fill (inner), inset by the border thickness
            Rectangle {
                anchors.fill: parent
                anchors.margins: 2
                radius: parent.radius - anchors.margins
                color: Theme.background
            }
        }

        // ==========================================
        // BUTTON LAYOUT
        // ==========================================
        ColumnLayout {
            id: buttonLayout
            anchors.centerIn: parent
            spacing: 20

            component PowerButton: Rectangle {
                id: btn
                property string iconSrc: ""
                property string cmd: ""
                property bool selected: false

                // Add a custom signal to the component
                signal clicked()

                implicitWidth: 50
                implicitHeight: 50
                radius: 25

                color: (mouseArea.containsMouse || selected) ? Theme.primary : "transparent"
                border.color: Theme.primary
                border.width: 1

                Image {
                    id: btnIcon
                    anchors.centerIn: parent
                    source: btn.iconSrc
                    width: 22
                    height: 22
                    sourceSize.width: 22
                    sourceSize.height: 22
                    fillMode: Image.PreserveAspectFit
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: (mouseArea.containsMouse || btn.selected) ? Theme.background : Theme.primary
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        // 1. Emit our custom clicked signal
                        btn.clicked()
                        // 2. Trigger the slide-out animation!
                        root.isOpen = false
                    }
                }
            }

            PowerButton {
                iconSrc: "../shared/icons/lock.svg"
                selected: root.selectedIndex === 0
                onClicked: { Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-power -l"]) }
            }
            PowerButton {
                iconSrc: "../shared/icons/suspend.svg"
                selected: root.selectedIndex === 1
                onClicked: { Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-power -s"]) }
            }
            PowerButton {
                iconSrc: "../shared/icons/logout.svg"
                selected: root.selectedIndex === 2
                onClicked: { Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-power -e"]) }
            }
            PowerButton {
                iconSrc: "../shared/icons/reboot.svg"
                selected: root.selectedIndex === 3
                onClicked: { Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-power -r"]) }
            }
            PowerButton {
                iconSrc: "../shared/icons/power.svg"
                selected: root.selectedIndex === 4
                onClicked: { Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-power -p"]) }
            }
        }
    }
}
