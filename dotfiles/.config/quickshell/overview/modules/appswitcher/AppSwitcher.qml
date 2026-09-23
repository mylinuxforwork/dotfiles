import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import "../../services"

Scope {
    id: switcherScope

    property var activeWorkspaceId: Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1
    property color accentColor: "#ffb4a4"

    Process {
        id: themeReader
        command: ["cat", Quickshell.env("HOME") + "/.config/ml4w/colors/primary"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var hex = this.text.trim();
                if (hex.length >= 4 && hex.startsWith("#")) {
                    switcherScope.accentColor = hex;
                }
            }
        }
    }

    Connections {
        target: GlobalStates
        function onAppSwitcherOpenChanged() {
            if (GlobalStates.appSwitcherOpen) {
                themeReader.running = true;
            }
        }
    }

    property var currentWindows: {
        if (!HyprlandData.windowList) return [];
        var list = [];
        for (var i = 0; i < HyprlandData.windowList.length; i++) {
            var w = HyprlandData.windowList[i];
            if (w && w.workspace && w.workspace.id === switcherScope.activeWorkspaceId && !w.hidden) {
                list.push(w);
            }
        }
        list.sort(function(a, b) {
            return (a.focusHistoryID || 0) - (b.focusHistoryID || 0);
        });
        return list;
    }

    function findToplevel(addr) {
        if (!addr || !ToplevelManager.toplevels) return null;
        var cleanAddr = addr.replace(/^0x/, "").toLowerCase();
        var toplevels = ToplevelManager.toplevels.values;
        for (var i = 0; i < toplevels.length; i++) {
            var top = toplevels[i];
            if (top && top.HyprlandToplevel && top.HyprlandToplevel.address) {
                if (top.HyprlandToplevel.address.toLowerCase() === cleanAddr) {
                    return top;
                }
            }
        }
        return null;
    }

    function getAppName(winClass) {
        if (!winClass) return "App";
        var entry = DesktopEntries.heuristicLookup(winClass);
        if (entry && entry.name) {
            return entry.name;
        }
        var parts = winClass.split(".");
        var name = parts[parts.length - 1];
        return name.charAt(0).toUpperCase() + name.slice(1);
    }

    function getAppIcon(winClass) {
        if (!winClass) return "application-x-executable";
        var entry = DesktopEntries.heuristicLookup(winClass);
        if (entry && entry.icon) {
            var raw = `${entry.icon}`.trim();
            var clean = raw.replace(/^image:\/\/icon\//, "").split("?")[0].trim();
            if (clean.length > 0) return clean;
        }
        return winClass;
    }

    function getCleanSubtitle(rawTitle, appName) {
        if (!rawTitle) return "Active Window";
        var t = ("" + rawTitle).trim();
        if (t === "" || t === "-" || t.toLowerCase() === (appName || "").toLowerCase()) {
            return "Active Window";
        }
        if (t === "~" || t === "~/") {
            return "Home (~/)";
        }
        return t;
    }

    property bool hudVisible: false

    Timer {
        id: displayTimer
        interval: 150
        repeat: false
        onTriggered: {
            if (GlobalStates.appSwitcherOpen) {
                switcherScope.hudVisible = true;
            }
        }
    }

    Timer {
        id: quickTapCommitTimer
        interval: 220
        repeat: false
        onTriggered: {
            if (GlobalStates.appSwitcherOpen && !switcherScope.hudVisible) {
                switcherScope.activateWindow(GlobalStates.appSwitcherIndex);
            }
        }
    }

    Process {
        id: focusProcess
        command: []
    }

    function activateWindow(index) {
        displayTimer.stop();
        quickTapCommitTimer.stop();
        switcherScope.hudVisible = false;

        var targetAddr = "";
        if (index >= 0 && index < currentWindows.length) {
            var target = currentWindows[index];
            if (target && target.address) {
                targetAddr = target.address;
            }
        }

        GlobalStates.appSwitcherOpen = false;

        if (targetAddr !== "") {
            focusProcess.command = ["hyprctl", "dispatch", "hl.dsp.focus({ window = 'address:" + targetAddr + "' })"];
            focusProcess.running = true;
        }
    }

    function closeSwitcher() {
        displayTimer.stop();
        quickTapCommitTimer.stop();
        switcherScope.hudVisible = false;
        GlobalStates.appSwitcherOpen = false;
    }

    function stepNext() {
        HyprlandData.updateWindowList();
        if (!GlobalStates.appSwitcherOpen) {
            GlobalStates.appSwitcherOpen = true;
            switcherScope.hudVisible = false;
            GlobalStates.appSwitcherIndex = (currentWindows.length > 1) ? 1 : 0;
            displayTimer.restart();
            quickTapCommitTimer.restart();
        } else {
            quickTapCommitTimer.stop();
            displayTimer.stop();
            switcherScope.hudVisible = true;
            if (currentWindows.length > 0) {
                GlobalStates.appSwitcherIndex = (GlobalStates.appSwitcherIndex + 1) % currentWindows.length;
            }
        }
    }

    function stepPrev() {
        HyprlandData.updateWindowList();
        if (!GlobalStates.appSwitcherOpen) {
            GlobalStates.appSwitcherOpen = true;
            switcherScope.hudVisible = false;
            GlobalStates.appSwitcherIndex = (currentWindows.length > 0) ? (currentWindows.length - 1) : 0;
            displayTimer.restart();
            quickTapCommitTimer.restart();
        } else {
            quickTapCommitTimer.stop();
            displayTimer.stop();
            switcherScope.hudVisible = true;
            if (currentWindows.length > 0) {
                GlobalStates.appSwitcherIndex = (GlobalStates.appSwitcherIndex - 1 + currentWindows.length) % currentWindows.length;
            }
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: root
            required property var modelData
            readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.screen)
            property bool monitorIsFocused: (Hyprland.focusedMonitor?.id == monitor?.id)

            screen: modelData
            visible: GlobalStates.appSwitcherOpen

            WlrLayershell.namespace: "quickshell:appswitcher"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: (GlobalStates.appSwitcherOpen && monitorIsFocused) ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
            color: "transparent"

            implicitWidth: screen.width
            implicitHeight: screen.height

            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            HyprlandFocusGrab {
                id: grab
                windows: [root]
                property bool canBeActive: root.monitorIsFocused
                active: GlobalStates.appSwitcherOpen && root.monitorIsFocused
                onCleared: () => {
                    if (canBeActive && GlobalStates.appSwitcherOpen)
                        switcherScope.activateWindow(GlobalStates.appSwitcherIndex);
                }
            }

            Rectangle {
                anchors.fill: parent
                color: "#000000"
                opacity: (GlobalStates.appSwitcherOpen && switcherScope.hudVisible) ? 0.40 : 0.0

                Behavior on opacity {
                    NumberAnimation { duration: 140; easing.type: Easing.OutQuad }
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: switcherScope.closeSwitcher()
                }
            }

            Item {
                id: keyHandler
                anchors.fill: parent
                focus: true

                Connections {
                    target: GlobalStates
                    function onAppSwitcherOpenChanged() {
                        if (GlobalStates.appSwitcherOpen && root.monitorIsFocused) {
                            keyHandler.forceActiveFocus();
                        }
                    }
                }

                Keys.onPressed: function(event) {
                    displayTimer.stop();
                    quickTapCommitTimer.stop();
                    switcherScope.hudVisible = true;

                    if (event.key === Qt.Key_Escape) {
                        switcherScope.closeSwitcher();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Tab) {
                        if (event.modifiers & Qt.ShiftModifier) {
                            switcherScope.stepPrev();
                        } else {
                            switcherScope.stepNext();
                        }
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Right || event.key === Qt.Key_Down || event.key === Qt.Key_L || event.key === Qt.Key_J) {
                        switcherScope.stepNext();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Left || event.key === Qt.Key_Up || event.key === Qt.Key_H || event.key === Qt.Key_K) {
                        switcherScope.stepPrev();
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                        switcherScope.activateWindow(GlobalStates.appSwitcherIndex);
                        event.accepted = true;
                    }
                }

                Keys.onReleased: function(event) {
                    if (event.key === Qt.Key_Alt || event.key === Qt.Key_AltGr || event.key === Qt.Key_Meta || event.key === Qt.Key_Super_L || event.key === Qt.Key_Super_R) {
                        if (GlobalStates.appSwitcherOpen) {
                            switcherScope.activateWindow(GlobalStates.appSwitcherIndex);
                            event.accepted = true;
                        }
                    }
                }
            }

            Rectangle {
                id: hudCard
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -24

                readonly property int winCount: switcherScope.currentWindows.length
                readonly property int cardWidth: {
                    if (winCount <= 1) return 420;
                    if (winCount === 2) return 360;
                    if (winCount === 3) return 330;
                    if (winCount === 4) return 310;
                    return 300;
                }
                readonly property int cardSpacing: 14

                width: {
                    if (winCount <= 1) return 480;
                    if (winCount === 2) return 2 * cardWidth + cardSpacing + 48;
                    if (winCount === 3) return 3 * cardWidth + 2 * cardSpacing + 48;
                    if (winCount === 4) return 4 * cardWidth + 3 * cardSpacing + 48;
                    return Math.min(1440, screen.width - 100);
                }
                height: 380
                radius: 22
                color: Qt.rgba(0.08, 0.06, 0.06, 0.88)
                border.color: Qt.rgba(1.0, 1.0, 1.0, 0.08)
                border.width: 1

                scale: (GlobalStates.appSwitcherOpen && switcherScope.hudVisible) ? 1.0 : 0.96
                opacity: (GlobalStates.appSwitcherOpen && switcherScope.hudVisible) ? 1.0 : 0.0

                Behavior on scale {
                    NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
                }

                Behavior on width {
                    NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                }

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    // Minimalist Breadcrumb Header with Live Position
                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 8

                        Rectangle {
                            width: 6
                            height: 6
                            radius: 3
                            color: switcherScope.accentColor
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Text {
                            text: "Workspace " + switcherScope.activeWorkspaceId
                            font.family: "Fira Sans"
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            color: "#f5ece8"
                        }

                        Text {
                            text: "·"
                            font.family: "Fira Sans"
                            font.pixelSize: 13
                            color: Qt.rgba(1.0, 1.0, 1.0, 0.25)
                        }

                        Text {
                            text: switcherScope.currentWindows.length + (switcherScope.currentWindows.length === 1 ? " window" : " windows")
                            font.family: "Fira Sans"
                            font.pixelSize: 13
                            color: Qt.rgba(1.0, 1.0, 1.0, 0.50)
                        }

                        // Position indicator for large window sets
                        Text {
                            visible: switcherScope.currentWindows.length >= 4
                            text: "·"
                            font.family: "Fira Sans"
                            font.pixelSize: 13
                            color: Qt.rgba(1.0, 1.0, 1.0, 0.25)
                        }

                        Text {
                            visible: switcherScope.currentWindows.length >= 4
                            text: (GlobalStates.appSwitcherIndex + 1) + " of " + switcherScope.currentWindows.length
                            font.family: "Fira Sans"
                            font.pixelSize: 13
                            font.weight: Font.Medium
                            color: switcherScope.accentColor
                        }
                    }

                    // Carousel Stage for Windows (Never Squishes!)
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        ListView {
                            id: cardsListView
                            anchors.fill: parent
                            orientation: ListView.Horizontal
                            spacing: hudCard.cardSpacing
                            clip: true

                            model: switcherScope.currentWindows
                            currentIndex: GlobalStates.appSwitcherIndex

                            highlightRangeMode: ListView.ApplyRange
                            preferredHighlightBegin: Math.max(0, (width - hudCard.cardWidth) / 2)
                            preferredHighlightEnd: Math.min(width, (width + hudCard.cardWidth) / 2)
                            highlightMoveDuration: 180

                            snapMode: ListView.SnapToItem
                            boundsBehavior: Flickable.StopAtBounds

                            Connections {
                                target: GlobalStates
                                function onAppSwitcherIndexChanged() {
                                    if (cardsListView.count > 0 && GlobalStates.appSwitcherIndex >= 0 && GlobalStates.appSwitcherIndex < cardsListView.count) {
                                        cardsListView.currentIndex = GlobalStates.appSwitcherIndex;
                                        cardsListView.positionViewAtIndex(GlobalStates.appSwitcherIndex, ListView.Center);
                                    }
                                }
                            }

                            // Mouse wheel cycling
                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.NoButton
                                onWheel: function(wheel) {
                                    if (wheel.angleDelta.y < 0 || wheel.angleDelta.x > 0) {
                                        switcherScope.stepNext();
                                    } else if (wheel.angleDelta.y > 0 || wheel.angleDelta.x < 0) {
                                        switcherScope.stepPrev();
                                    }
                                }
                            }

                            delegate: Item {
                                id: cardDelegate
                                required property var modelData
                                required property int index

                                width: hudCard.cardWidth
                                height: cardsListView.height

                                property bool isSelected: index === GlobalStates.appSwitcherIndex
                                property var toplevelSource: switcherScope.findToplevel(modelData.address)
                                property string friendlyName: switcherScope.getAppName(modelData.class)
                                property string friendlyIcon: switcherScope.getAppIcon(modelData.class)
                                property string cleanSubtitle: switcherScope.getCleanSubtitle(modelData.title, friendlyName)

                                Rectangle {
                                    id: cardItem
                                    anchors.fill: parent
                                    anchors.margins: 4
                                    radius: 16
                                    clip: true

                                    scale: cardDelegate.isSelected ? 1.025 : 0.985
                                    opacity: cardDelegate.isSelected ? 1.0 : 0.60

                                    Behavior on scale {
                                        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
                                    }

                                    Behavior on opacity {
                                        NumberAnimation { duration: 140; easing.type: Easing.OutQuad }
                                    }

                                    color: cardDelegate.isSelected
                                        ? Qt.rgba(switcherScope.accentColor.r, switcherScope.accentColor.g, switcherScope.accentColor.b, 0.08)
                                        : Qt.rgba(1.0, 1.0, 1.0, 0.025)

                                    border.color: cardDelegate.isSelected
                                        ? switcherScope.accentColor
                                        : Qt.rgba(1.0, 1.0, 1.0, 0.06)
                                    border.width: cardDelegate.isSelected ? 1.5 : 1

                                    Behavior on color {
                                        ColorAnimation { duration: 120 }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        hoverEnabled: true
                                        onEntered: GlobalStates.appSwitcherIndex = cardDelegate.index
                                        onClicked: switcherScope.activateWindow(cardDelegate.index)
                                    }

                                    ColumnLayout {
                                        anchors.fill: parent
                                        anchors.margins: 8
                                        spacing: 8

                                        // Top Canvas: Crisp Framed 16:10 / 16:9 Live Window Preview
                                        Rectangle {
                                            Layout.fillWidth: true
                                            Layout.fillHeight: true
                                            radius: 11
                                            clip: true
                                            color: "#080606"

                                            ScreencopyView {
                                                anchors.fill: parent
                                                captureSource: cardDelegate.toplevelSource
                                                live: GlobalStates.appSwitcherOpen
                                                visible: cardDelegate.toplevelSource !== null
                                            }

                                            // Fallback Icon when screencopy is resolving
                                            Image {
                                                anchors.centerIn: parent
                                                width: 56
                                                height: 56
                                                visible: cardDelegate.toplevelSource === null
                                                source: Quickshell.iconPath(cardDelegate.friendlyIcon, "application-x-executable")
                                                fillMode: Image.PreserveAspectFit
                                            }
                                        }

                                        // Bottom Area: Compact Icon Badge + Title + Subtitle
                                        Item {
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: 52

                                            RowLayout {
                                                anchors.fill: parent
                                                anchors.leftMargin: 6
                                                anchors.rightMargin: 6
                                                spacing: 12

                                                Rectangle {
                                                    Layout.preferredWidth: 36
                                                    Layout.preferredHeight: 36
                                                    radius: 8
                                                    color: Qt.rgba(1.0, 1.0, 1.0, 0.05)
                                                    border.color: Qt.rgba(1.0, 1.0, 1.0, 0.06)
                                                    border.width: 1

                                                    Image {
                                                        anchors.centerIn: parent
                                                        width: 24
                                                        height: 24
                                                        sourceSize: Qt.size(24, 24)
                                                        source: Quickshell.iconPath(cardDelegate.friendlyIcon, "application-x-executable")
                                                        fillMode: Image.PreserveAspectFit
                                                    }
                                                }

                                                ColumnLayout {
                                                    Layout.fillWidth: true
                                                    Layout.alignment: Qt.AlignVCenter
                                                    spacing: 2

                                                    Text {
                                                        Layout.fillWidth: true
                                                        text: cardDelegate.friendlyName
                                                        font.family: "Fira Sans"
                                                        font.pixelSize: 14
                                                        font.weight: Font.DemiBold
                                                        color: cardDelegate.isSelected ? "#ffffff" : "#ded6d2"
                                                        elide: Text.ElideRight
                                                    }

                                                    Text {
                                                        Layout.fillWidth: true
                                                        text: cardDelegate.cleanSubtitle
                                                        font.family: "Fira Sans"
                                                        font.pixelSize: 11
                                                        color: cardDelegate.isSelected
                                                            ? Qt.rgba(1.0, 1.0, 1.0, 0.70)
                                                            : Qt.rgba(1.0, 1.0, 1.0, 0.40)
                                                        elide: Text.ElideMiddle
                                                        maximumLineCount: 1
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "app-switcher"

        function next(): void {
            switcherScope.stepNext();
        }

        function prev(): void {
            switcherScope.stepPrev();
        }

        function toggle(): void {
            if (GlobalStates.appSwitcherOpen) {
                switcherScope.closeSwitcher();
            } else {
                switcherScope.stepNext();
            }
        }

        function close(): void {
            switcherScope.closeSwitcher();
        }

        function release(): void {
            if (GlobalStates.appSwitcherOpen) {
                switcherScope.activateWindow(GlobalStates.appSwitcherIndex);
            }
        }

        function select(): void {
            switcherScope.activateWindow(GlobalStates.appSwitcherIndex);
        }
    }
}
