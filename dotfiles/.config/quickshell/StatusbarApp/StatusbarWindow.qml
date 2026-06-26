import Quickshell
import Quickshell.Wayland
import Quickshell.Io
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

        // Collapsed = sized to content, Expanded = fixed width.
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

            TerminalModule {}
            WorkspacesModule {}
        }

        // ==========================================
        // CENTER AREA (always visible)
        // ==========================================
        RowLayout {
            id: centerArea
            anchors.centerIn: parent
            spacing: 14

            LauncherModule {}
            ClockModule {
                Layout.alignment: Qt.AlignVCenter
                expanded: pill.expanded
            }
            Ml4wLogoModule {}
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

            SystemTrayModule {}
            PowerModule {}
        }
    }
}
