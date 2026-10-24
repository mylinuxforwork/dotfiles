import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import Qt.labs.folderlistmodel
import qs.CustomTheme

PanelWindow {
    id: root

    // --- WAYLAND CONFIGURATION ---
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "ml4w-wallpaper-carousel"
    WlrLayershell.keyboardFocus: isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    // --- POSITIONING ---
    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    // Open on the focused monitor. Set only when opening, because changing
    // the screen of a visible window recreates it.
    property var targetScreen: null
    screen: targetScreen

    // --- ANIMATION LOGIC ---
    property bool isOpen: false
    visible: isOpen || fadeAnim.running

    // While applying, the cards fade out and the backdrop cross-fades to
    // the selected wallpaper. The real wallpaper is set without a transition
    // behind it, so it is already in place when the carousel closes after
    // applyDelay.
    property bool applying: false
    property string appliedWallpaper: ""
    readonly property int applyDelay: 1000

    onVisibleChanged: {
        if (!visible) {
            applying = false
            appliedWallpaper = ""
        }
    }

    onIsOpenChanged: {
        if (isOpen) {
            focusCurrentWallpaper()
            keyHandler.forceActiveFocus()
        }
    }

    // --- IPC HANDLER ---
    IpcHandler {
        target: "wallpaper-carousel"
        function toggle(): void { root.isOpen ? root.close() : root.open() }
        function open(): void { root.open() }
        function close(): void { root.close() }
        function isOpen(): bool { return root.isOpen }
    }

    function open(): void {
        const focused = Hyprland.focusedMonitor
        if (focused)
            root.targetScreen = Quickshell.screens.find(s => s.name === focused.name) ?? null
        closeTimer.stop()
        root.applying = false
        root.isOpen = true
    }

    function close(): void {
        root.isOpen = false
    }

    function applyWallpaper(index): void {
        const filePath = folderModel.get(index, "filePath")
        if (!filePath || root.applying)
            return
        root.applying = true
        root.appliedWallpaper = filePath
        WallpaperService.apply(filePath, ["--transition", "none"])
        closeTimer.restart()
    }

    Timer {
        id: closeTimer
        interval: root.applyDelay
        onTriggered: root.close()
    }

    // Center the view on the current wallpaper without animating
    function focusCurrentWallpaper(): void {
        if (folderModel.count === 0)
            return
        let index = 0
        for (let i = 0; i < folderModel.count; i++) {
            if (WallpaperService.isCurrent(folderModel.get(i, "fileName"))) {
                index = i
                break
            }
        }
        view.positionViewAtIndex(index, PathView.Center)
        view.currentIndex = index
    }

    // --- CARD GEOMETRY ---
    // Size of the card in the center. Cards towards the edges are scaled
    // down along the path (see the PathAttributes below).
    property real cardHeight: Math.round(height * 0.36)
    property real cardWidth: Math.round(cardHeight * 0.4)
    property real cardGap: 8

    // Cards shrink linearly from 1.0 in the center to edgeScale at the
    // screen edges. The PathPercent values space them so the gap between
    // neighbours shrinks with them: percent(x) = ln(1 - a*x) / ln(1 - a)
    // with a = 1 - edgeScale. Covering the width W then takes
    // W / (cardWidth + gap) * ln(1 / edgeScale) / (1 - edgeScale) cards.
    readonly property real edgeScale: 0.4
    readonly property int maxVisibleCards: Math.max(3, Math.round(width / (cardWidth + cardGap) * 1.527))

    FolderListModel {
        id: folderModel
        folder: WallpaperService.wallpaperFolder === "" ? "" : "file://" + WallpaperService.wallpaperFolder
        showDirs: false
        caseSensitive: false
        sortField: FolderListModel.Name
        nameFilters: ["*.jpg", "*.jpeg", "*.png"]

        onStatusChanged: {
            if (status === FolderListModel.Ready && root.isOpen)
                root.focusCurrentWallpaper()
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: root.isOpen ? 1.0 : 0.0
        scale: root.isOpen ? 1.0 : 0.97

        Behavior on opacity {
            NumberAnimation {
                id: fadeAnim
                duration: 220
                easing.type: Easing.OutCubic
            }
        }
        Behavior on scale {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutCubic
            }
        }

        // --- BACKDROP (current wallpaper, click to close) ---
        Rectangle {
            anchors.fill: parent
            color: Theme.background

            Image {
                anchors.fill: parent
                source: WallpaperService.currentWallpaper === "" ? "" : "file://" + WallpaperService.currentWallpaper
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                sourceSize.width: root.width
                sourceSize.height: root.height
            }

            // Selected wallpaper, faded in on top while applying
            Image {
                id: appliedBackdrop
                anchors.fill: parent
                source: root.appliedWallpaper === "" ? "" : "file://" + root.appliedWallpaper
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                sourceSize.width: root.width
                sourceSize.height: root.height
                opacity: root.applying && status === Image.Ready ? 1.0 : 0.0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.35)
                opacity: root.applying ? 0.0 : 1.0
                Behavior on opacity {
                    NumberAnimation {
                        duration: 600
                        easing.type: Easing.InOutCubic
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.close()
            }
        }

        // --- KEYBOARD ---
        Item {
            id: keyHandler
            focus: true
            Keys.onPressed: (event) => {
                if (root.applying && event.key !== Qt.Key_Escape) {
                    event.accepted = true
                    return
                }
                switch (event.key) {
                case Qt.Key_Left:
                    view.decrementCurrentIndex()
                    break
                case Qt.Key_Right:
                    view.incrementCurrentIndex()
                    break
                case Qt.Key_Return:
                case Qt.Key_Enter:
                    root.applyWallpaper(view.currentIndex)
                    break
                case Qt.Key_Escape:
                    root.close()
                    break
                default:
                    return
                }
                event.accepted = true
            }
        }

        // --- MOUSE WHEEL ---
        // Move one card per wheel notch (120 units). Touchpads send many
        // small deltas, so add them up instead of stepping on every event.
        WheelHandler {
            property real accumulated: 0
            acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
            onWheel: (event) => {
                if (root.applying)
                    return
                const delta = event.angleDelta.y !== 0 ? event.angleDelta.y : event.angleDelta.x
                accumulated += delta
                while (accumulated >= 120) {
                    view.decrementCurrentIndex()
                    accumulated -= 120
                }
                while (accumulated <= -120) {
                    view.incrementCurrentIndex()
                    accumulated += 120
                }
            }
        }

        // --- ERROR MSG FOR EMPTY OR INVALID DIRECTORY ---
        Text {
            anchors.centerIn: parent
            visible: folderModel.status === FolderListModel.Ready && folderModel.count === 0
            color: Theme.primary
            font.family: Theme.fontFamily
            font.pixelSize: 16
            text: "Wallpaper folder is either empty or invalid."
        }

        // --- CAROUSEL ---
        PathView {
            id: view
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            height: root.cardHeight + 60
            enabled: !root.applying
            opacity: root.applying ? 0.0 : 1.0
            Behavior on opacity {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }

            model: folderModel
            pathItemCount: Math.min(folderModel.count, root.maxVisibleCards)
            cacheItemCount: 4
            interactive: false

            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            highlightRangeMode: PathView.StrictlyEnforceRange
            highlightMoveDuration: 300

            // With fewer wallpapers than slots, PathView spreads them over the
            // whole path. Shorten the path instead so the cards stay close.
            readonly property real pathWidth: width * Math.min(1, folderModel.count / root.maxVisibleCards)
            readonly property real pathLeft: (width - pathWidth) / 2

            path: Path {
                startX: view.pathLeft
                startY: view.height / 2

                PathAttribute { name: "itemScale"; value: root.edgeScale }
                PathAttribute { name: "itemZ"; value: 0 }
                PathAttribute { name: "itemOpacity"; value: 0.6 }

                PathLine { x: view.pathLeft + view.pathWidth * 0.125; y: view.height / 2 }
                PathPercent { value: 0.1738 }
                PathAttribute { name: "itemScale"; value: 0.55 }
                PathAttribute { name: "itemZ"; value: 1 }
                PathAttribute { name: "itemOpacity"; value: 0.7 }

                PathLine { x: view.pathLeft + view.pathWidth * 0.25; y: view.height / 2 }
                PathPercent { value: 0.3054 }
                PathAttribute { name: "itemScale"; value: 0.7 }
                PathAttribute { name: "itemZ"; value: 2 }
                PathAttribute { name: "itemOpacity"; value: 0.8 }

                PathLine { x: view.pathLeft + view.pathWidth * 0.375; y: view.height / 2 }
                PathPercent { value: 0.4113 }
                PathAttribute { name: "itemScale"; value: 0.85 }
                PathAttribute { name: "itemZ"; value: 3 }
                PathAttribute { name: "itemOpacity"; value: 0.9 }

                PathLine { x: view.pathLeft + view.pathWidth * 0.5; y: view.height / 2 }
                PathPercent { value: 0.5 }
                PathAttribute { name: "itemScale"; value: 1.0 }
                PathAttribute { name: "itemZ"; value: 4 }
                PathAttribute { name: "itemOpacity"; value: 1.0 }

                PathLine { x: view.pathLeft + view.pathWidth * 0.625; y: view.height / 2 }
                PathPercent { value: 0.5887 }
                PathAttribute { name: "itemScale"; value: 0.85 }
                PathAttribute { name: "itemZ"; value: 3 }
                PathAttribute { name: "itemOpacity"; value: 0.9 }

                PathLine { x: view.pathLeft + view.pathWidth * 0.75; y: view.height / 2 }
                PathPercent { value: 0.6946 }
                PathAttribute { name: "itemScale"; value: 0.7 }
                PathAttribute { name: "itemZ"; value: 2 }
                PathAttribute { name: "itemOpacity"; value: 0.8 }

                PathLine { x: view.pathLeft + view.pathWidth * 0.875; y: view.height / 2 }
                PathPercent { value: 0.8262 }
                PathAttribute { name: "itemScale"; value: 0.55 }
                PathAttribute { name: "itemZ"; value: 1 }
                PathAttribute { name: "itemOpacity"; value: 0.7 }

                PathLine { x: view.pathLeft + view.pathWidth; y: view.height / 2 }
                PathPercent { value: 1.0 }
                PathAttribute { name: "itemScale"; value: root.edgeScale }
                PathAttribute { name: "itemZ"; value: 0 }
                PathAttribute { name: "itemOpacity"; value: 0.6 }
            }

            delegate: Item {
                id: card
                required property int index
                required property string filePath

                readonly property bool isCurrent: PathView.isCurrentItem

                width: root.cardWidth
                height: root.cardHeight
                scale: PathView.itemScale ?? root.edgeScale
                z: PathView.itemZ ?? 0
                opacity: PathView.itemOpacity ?? 0.6

                RectangularShadow {
                    anchors.fill: frame
                    radius: frame.radius
                    offset.y: 6
                    blur: 20
                    color: Qt.rgba(Theme.shadow.r, Theme.shadow.g, Theme.shadow.b, 0.5)
                }

                ClippingRectangle {
                    id: frame
                    anchors.fill: parent
                    radius: 12
                    color: Theme.secondary_container

                    Image {
                        anchors.fill: parent
                        source: "file://" + card.filePath
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        sourceSize.width: root.cardWidth
                        sourceSize.height: root.cardHeight

                        opacity: status === Image.Ready ? 1.0 : 0.0
                        Behavior on opacity {
                            NumberAnimation {
                                duration: 350
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }

                // Border on top of the image
                Rectangle {
                    anchors.fill: parent
                    radius: frame.radius
                    color: "transparent"
                    border.width: card.isCurrent ? 3 : 2
                    border.color: card.isCurrent ? Theme.on_primary : Theme.primary
                    Behavior on border.color { ColorAnimation { duration: 200 } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        view.currentIndex = card.index
                        root.applyWallpaper(card.index)
                    }
                }
            }
        }

        // --- FILE NAME OF THE FOCUSED WALLPAPER ---
        Text {
            anchors.top: view.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(parent.width - 40, 600)
            opacity: view.opacity
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideMiddle
            color: Theme.primary
            font.family: Theme.fontFamily
            font.pixelSize: 14
            text: folderModel.count > 0 ? (folderModel.get(view.currentIndex, "fileName") ?? "") : ""
        }
    }
}
