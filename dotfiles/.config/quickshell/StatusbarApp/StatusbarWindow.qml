import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import qs.CustomTheme

PanelWindow {
    id: root

    // --- WAYLAND CONFIGURATION ---
    WlrLayershell.layer: WlrLayer.Top

    property int barHeight: 40
    // Constant vertical space reserved for the bar (windows tile below this).
    property int reservedHeight: 72

    // Whether the bar is shown. Persisted via a state file so the choice
    // survives restarts and is honored on Hyprland startup. Toggled from the
    // SidebarApp (and via "qs ipc call statusbar toggle").
    property bool barEnabled: true

    // Hide completely and reserve no space when disabled.
    visible: barEnabled
    // Reserve 20px less than the band so the gap below the pill is smaller
    // than above (windows tile 20px higher).
    exclusiveZone: barEnabled ? reservedHeight - 20 : 0

    // Read the persisted state on startup.
    Process {
        id: stateProc
        command: ["bash", "-c", "test -f ~/.config/ml4w/settings/statusbar-disabled && echo 0 || echo 1"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: root.barEnabled = (this.text.trim() === "1")
        }
    }

    function persistState(): void {
        let cmd = root.barEnabled
            ? "rm -f ~/.config/ml4w/settings/statusbar-disabled"
            : "touch ~/.config/ml4w/settings/statusbar-disabled"
        Quickshell.execDetached(["bash", "-c", cmd])
    }

    IpcHandler {
        target: "statusbar"
        function toggle(): void { root.barEnabled = !root.barEnabled; root.persistState() }
        function show(): void { root.barEnabled = true; root.persistState() }
        function hide(): void { root.barEnabled = false; root.persistState() }
        // Re-read the state file (used by the SidebarApp switch).
        function refresh(): void { stateProc.running = false; stateProc.running = true }
    }

    color: "transparent"

    // Full-width strip anchored to the top of the screen
    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 0
    }

    implicitHeight: barHeight + 40

    // Live clock, only ticks once per minute
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // ==========================================
    // CENTERED PILL
    // ==========================================
    Item {
        id: pill
        anchors.horizontalCenter: parent.horizontalCenter
        // Center the pill within the reserved band. The window is taller than
        // the band (to fit the shadow / expanded pill), so offset accordingly.
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: (root.reservedHeight / 2) - (root.implicitHeight / 2)

        // Collapsed = sized to content, Expanded = 50% of the screen width
        property bool expanded: hoverHandler.hovered
        property real collapsedWidth: centerArea.implicitWidth + 32
        property real expandedWidth: 680

        width: expanded ? expandedWidth : collapsedWidth
        height: expanded ? root.barHeight + 10 : root.barHeight

        Behavior on width {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutQuint
            }
        }

        Behavior on height {
            NumberAnimation {
                duration: 350
                easing.type: Easing.OutQuint
            }
        }

        HoverHandler {
            id: hoverHandler
        }

        RectangularShadow {
            anchors.fill: pillBg
            radius: pillBg.radius
            blur: 15
            color: Qt.rgba(Theme.shadow.r, Theme.shadow.g, Theme.shadow.b, 0.4)
        }

        Rectangle {
            id: pillBg
            anchors.fill: parent
            color: Theme.background
            border.color: Theme.primary
            border.width: 2
            radius: height / 2
            opacity: 0.9
        }

        // --- Reusable icon button ---
        component BarButton: Rectangle {
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

        // ==========================================
        // LEFT AREA (only visible when expanded)
        // ==========================================
        RowLayout {
            id: leftArea
            anchors.left: parent.left
            anchors.leftMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14

            opacity: pill.expanded ? 1 : 0
            visible: opacity > 0
            enabled: pill.expanded

            Behavior on opacity {
                NumberAnimation { duration: 250; easing.type: Easing.OutQuint }
            }

            // Terminal launcher
            BarButton {
                iconSrc: "../shared/icons/terminal.svg"
                onClicked: {
                    Quickshell.execDetached(["bash", "-c",
                        Quickshell.env("HOME") + "/.config/ml4w/settings/terminal.sh"])
                }
            }

            // Hyprland workspace switcher
            RowLayout {
                spacing: 6

                Repeater {
                    model: Hyprland.workspaces

                    delegate: Rectangle {
                        id: ws
                        required property var modelData

                        implicitWidth: 26
                        implicitHeight: 26
                        radius: 13

                        color: modelData.focused
                            ? Theme.primary
                            : (wsMouse.containsMouse ? Theme.surface_container_high : "transparent")
                        border.color: Theme.primary
                        border.width: modelData.focused ? 0 : 1

                        Text {
                            anchors.centerIn: parent
                            text: ws.modelData.id
                            color: ws.modelData.focused ? Theme.background : Theme.on_background
                            font.family: Theme.fontFamily
                            font.pixelSize: 13
                            font.bold: true
                        }

                        MouseArea {
                            id: wsMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: ws.modelData.activate()
                        }
                    }
                }
            }
        }

        // ==========================================
        // CENTER AREA (always visible)
        // ==========================================
        RowLayout {
            id: centerArea
            anchors.centerIn: parent
            spacing: 14

            // App launcher
            BarButton {
                iconSrc: "../shared/icons/launcher.svg"
                onClicked: {
                    Quickshell.execDetached(["bash", "-c",
                        Quickshell.env("HOME") + "/.config/hypr/scripts/launcher.sh"])
                }
            }

            // Clock (time, with date hanging below when expanded)
            Item {
                Layout.alignment: Qt.AlignVCenter
                implicitWidth: Math.max(timeText.implicitWidth, dateText.implicitWidth)
                implicitHeight: timeText.implicitHeight

                Text {
                    id: timeText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    // Shift up when expanded so the date below has more room
                    anchors.verticalCenterOffset: pill.expanded ? -6 : 0
                    Behavior on anchors.verticalCenterOffset {
                        NumberAnimation { duration: 250; easing.type: Easing.OutQuint }
                    }
                    text: Qt.formatDateTime(clock.date, "HH:mm")
                    color: Theme.primary
                    font.family: Theme.fontFamily
                    font.pixelSize: 16
                    font.bold: true
                }

                Text {
                    id: dateText
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: timeText.bottom
                    anchors.topMargin: 1
                    text: Qt.formatDateTime(clock.date, "ddd, dd MMM")
                    color: Theme.primary
                    font.family: Theme.fontFamily
                    font.pixelSize: 11

                    opacity: pill.expanded ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation { duration: 250; easing.type: Easing.OutQuint }
                    }
                }
            }

            // ML4W logo -> toggle the Sidebar app via IPC
            BarButton {
                iconSrc: Quickshell.env("HOME") + "/.config/ml4w/assets/ml4w.svg"
                colorize: false
                onClicked: {
                    Quickshell.execDetached(["qs", "ipc", "call", "sidebar", "toggle"])
                }
            }
        }

        // ==========================================
        // RIGHT AREA (only visible when expanded)
        // ==========================================
        RowLayout {
            id: rightArea
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14

            opacity: pill.expanded ? 1 : 0
            visible: opacity > 0
            enabled: pill.expanded

            Behavior on opacity {
                NumberAnimation { duration: 250; easing.type: Easing.OutQuint }
            }

            // System tray
            RowLayout {
                spacing: 10

                Repeater {
                    model: SystemTray.items

                    delegate: MouseArea {
                        id: trayItem
                        required property var modelData

                        implicitWidth: 20
                        implicitHeight: 20
                        Layout.alignment: Qt.AlignVCenter
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        Image {
                            anchors.centerIn: parent
                            source: trayItem.modelData.icon
                            width: 18
                            height: 18
                            sourceSize.width: 18
                            sourceSize.height: 18
                            fillMode: Image.PreserveAspectFit
                        }

                        onClicked: (mouse) => {
                            if (mouse.button === Qt.LeftButton && !modelData.onlyMenu) {
                                modelData.activate()
                            } else if (modelData.hasMenu) {
                                trayMenu.open()
                            }
                        }

                        QsMenuAnchor {
                            id: trayMenu
                            menu: trayItem.modelData.menu
                            anchor.item: trayItem
                            anchor.edges: Edges.Bottom
                            anchor.gravity: Edges.Bottom
                        }
                    }
                }
            }

            // Power menu -> toggle the Power app via IPC
            BarButton {
                iconSrc: "../shared/icons/power.svg"
                onClicked: {
                    Quickshell.execDetached(["qs", "ipc", "call", "power", "toggle"])
                }
            }
        }
    }
}
