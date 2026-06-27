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
    // Grab the keyboard while expanded so the IPC toggle (SUPER + SPACE) can
    // focus the bar for Left/Right/Return navigation without touching the
    // mouse. Exclusive is required for this programmatic grab; to keep apps
    // usable, expanded mode behaves like a transient menu: it auto-collapses
    // (releasing the keyboard) as soon as a module is run (Return) or the
    // user cancels (Escape).
    WlrLayershell.keyboardFocus: root.barExpanded
        ? WlrKeyboardFocus.Exclusive
        : WlrKeyboardFocus.None

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

    // Keep the pill expanded regardless of hover. Toggled via IPC
    // ("qs ipc call statusbar expand") and bound to SUPER + SPACE in Hyprland.
    property bool barExpanded: false

    // --- KEYBOARD NAVIGATION ---
    // Ordered left-to-right list of the navigable items. The workspace buttons
    // are spliced in after the terminal to match their on-screen position;
    // their count is dynamic, so navItems is a binding that re-evaluates when
    // workspaces are added or removed. Collection modules without a single
    // action (the system tray) are skipped.
    readonly property var navItems: [terminalModule]
        .concat(workspacesModule.navButtons)
        .concat([launcherModule, clockModule, logoModule, swayncModule, powerModule])
    // Index of the keyboard-selected item, or -1 when none is selected.
    property int focusIndex: -1

    // Highlight exactly the item at focusIndex and clear all others. Called
    // both when the selection moves and when navItems changes underneath it.
    function applyFocus(): void {
        let items = root.navItems
        for (let i = 0; i < items.length; i++)
            items[i].focused = (i === root.focusIndex)
    }

    onFocusIndexChanged: applyFocus()
    onNavItemsChanged: {
        // Keep the selection in range when the workspace count changes.
        if (root.focusIndex >= root.navItems.length)
            root.focusIndex = root.navItems.length - 1
        applyFocus()
    }

    onBarExpandedChanged: {
        if (barExpanded) {
            focusIndex = 0
            keyHandler.forceActiveFocus()
        } else {
            focusIndex = -1
        }
    }

    function moveFocus(dir: int): void {
        if (!barExpanded)
            return
        let n = root.navItems.length
        root.focusIndex = (root.focusIndex + dir + n) % n
    }

    function activateFocused(): void {
        if (root.focusIndex >= 0 && root.focusIndex < root.navItems.length)
            root.navItems[root.focusIndex].activate()
        // Collapse so the keyboard is handed back to the (possibly newly
        // launched) application instead of staying captured by the bar.
        root.barExpanded = false
    }

    IpcHandler {
        target: "statusbar"
        function toggle(): void { root.barEnabled = !root.barEnabled; root.persistState() }
        function show(): void { root.barEnabled = true; root.persistState() }
        function hide(): void { root.barEnabled = false; root.persistState() }
        // Re-read the state file (used by the SidebarApp switch).
        function refresh(): void { stateProc.running = false; stateProc.running = true }
        // Toggle between collapsed and expanded mode.
        function expand(): void { root.barExpanded = !root.barExpanded }
        function collapse(): void { root.barExpanded = false }
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
        property bool expanded: hoverHandler.hovered || root.barExpanded
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

        // Captures arrow keys (navigate), Return (execute) and Escape
        // (collapse) while the bar is in expanded mode.
        FocusScope {
            anchors.fill: parent
            focus: root.barExpanded
            Keys.onLeftPressed: root.moveFocus(-1)
            Keys.onRightPressed: root.moveFocus(1)
            Keys.onReturnPressed: root.activateFocused()
            Keys.onEnterPressed: root.activateFocused()
            Keys.onEscapePressed: root.barExpanded = false
        }

        RectangularShadow {
            anchors.fill: pillBg
            radius: pillBg.radius
            blur: 15
            color: Qt.rgba(Theme.shadow.r, Theme.shadow.g, Theme.shadow.b, 0.4)
        }

        // Gradient BORDER layer (outer)
        Rectangle {
            id: pillBg
            anchors.fill: parent
            radius: 12
            opacity: pill.expanded ? 0.8 : 0.5
            Behavior on opacity {
                NumberAnimation { duration: 350; easing.type: Easing.OutQuint }
            }

            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Theme.primary }
                GradientStop { position: 1.0; color: Theme.on_primary }
            }

            // Actual background fill (inner), inset by the border thickness
            Rectangle {
                anchors.fill: parent
                anchors.margins: 2          // = border width
                radius: parent.radius - anchors.margins
                color: Theme.background
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

            TerminalModule {
                id: terminalModule
            }
            WorkspacesModule {
                id: workspacesModule
            }
        }

        // ==========================================
        // CENTER AREA (always visible)
        // ==========================================
        RowLayout {
            id: centerArea
            anchors.centerIn: parent
            spacing: 14

            LauncherModule {
                id: launcherModule
            }
            ClockModule {
                id: clockModule
                Layout.alignment: Qt.AlignVCenter
                expanded: pill.expanded
            }
            Ml4wLogoModule {
                id: logoModule
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

            SystemTrayModule {}
            SwayncModule {
                id: swayncModule
            }
            PowerModule {
                id: powerModule
            }
        }
    }
}
