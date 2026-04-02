import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland 
import Quickshell.Io
import Quickshell.Services.Mpris 
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.CustomTheme

PanelWindow {
    id: root
    
    // --- WAYLAND CONFIGURATION ---
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: WlrLayershell.Ignore
    
    implicitWidth: 380
    color: "transparent"

    property bool isHyprlandSettingsInstalled: false

    anchors {
        right: true
        top: true
        bottom: true
    }

    margins { 
        top: 87
        bottom: 20
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

    // --- ESCAPE KEY LISTENER ---
    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (root.isOpen) {
                root.isOpen = false
            }
        }
    }

    // --- ANIMATION LOGIC ---
    property bool isOpen: false
    visible: isOpen || slideAnim.running
    
    margins { right: root.currentMargin }
    property real currentMargin: isOpen ? 20 : -450 

    Behavior on currentMargin {
        NumberAnimation {
            id: slideAnim
            duration: 350
            easing.type: Easing.OutQuint 
        }
    }

    IpcHandler {
        target: "sidebar"
        function toggle(): void { root.isOpen = !root.isOpen }
        function open(): void { root.isOpen = true }   
        function close(): void { root.isOpen = false } 
    }

    // --- Check if flatpak is installed when window opens ---
    Process {
        command: ["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-flatpak-installed com.ml4w.hyprlandsettings"]
        running: root.visible
        
        stdout: StdioCollector {
            onStreamFinished: {
                console.log(this.text.trim())
                root.isHyprlandSettingsInstalled = (this.text.trim() === "0")
            }
        }
    }

    // --- REUSABLE COMPONENTS ---
    component ML4WMenuItem: MenuItem {
        id: control
        contentItem: Text {
            text: control.text
            font.family: Theme.fontFamily
            font.pixelSize: 14
            color: control.highlighted ? Theme.background : Theme.primary 
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            implicitWidth: 200
            implicitHeight: 36
            color: control.highlighted ? Theme.primary : "transparent"
            radius: 4
        }
    }

    component ML4WButton: Button {
        Layout.fillWidth: true
        background: Rectangle {
            color: "transparent"
            border.color: Theme.primary
            border.width: 1
            radius: 10
        }
        contentItem: Text {
            text: parent.text
            font.family: Theme.fontFamily
            font.pixelSize: 16
            color: Theme.primary
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            padding: 8
        }
    }

    component ML4WSwitch: Switch {
        Layout.alignment: Qt.AlignVCenter
        implicitWidth: 48
        implicitHeight: 26
        indicator: Rectangle {
            implicitWidth: 48
            implicitHeight: 26
            radius: 13
            color: parent.checked ? Theme.primary : Theme.background
            border.color: Theme.primary
            border.width: 1
            Rectangle {
                x: parent.parent.checked ? parent.width - width - 2 : 2
                y: 2
                implicitWidth: 22
                implicitHeight: 22
                radius: 11
                color: parent.parent.checked ? Theme.background : Theme.on_primary
                Behavior on x { NumberAnimation { duration: 150 } }
            }
        }
    }

    component SettingsWheel: Button {
        implicitWidth: 28  
        implicitHeight: 28
        text: "" 
        font.family: "monospace"
        background: Rectangle { color: "transparent" }
        contentItem: Text { 
            text: parent.text; color: Theme.primary; font.pixelSize: 18; 
            verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
        }
    }

    component ActionIcon: Button {
        property string iconTxt: ""
        implicitWidth: 28  
        implicitHeight: 28
        text: iconTxt
        font.family: "monospace"
        background: Rectangle { color: "transparent" }
        contentItem: Text { 
            text: parent.text; color: Theme.primary; font.pixelSize: 18; 
            verticalAlignment: Text.AlignVCenter; horizontalAlignment: Text.AlignHCenter
        }
    }

    // ==========================================
    // MAIN PANEL BACKGROUND
    // ==========================================
    Item {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            color: Theme.background
            border.color: Theme.primary
            border.width: 2
            radius: 10
            opacity: 0.95 // Only the background is transparent
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            // --- TOP BAR (Light/Dark, Screenshot & Color Picker) ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                ActionIcon {
                    iconTxt: "󰔎"
                    onClicked: {
                        Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-toggle-theme"])
                    }
                }

                ActionIcon {
                    iconTxt: "" 
                    onClicked: {
                        root.isOpen = false
                        Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/settings/hyprpicker.sh"])
                    }
                }

                ActionIcon { 
                    iconTxt: ""
                    onClicked: {
                        root.isOpen = false
                        Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/screenshot.sh"])
                    }
                }

                Item { Layout.fillWidth: true } 
            }

            Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.primary; opacity: 0.3 }

            // --- THREE BUTTONS ROW ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 10
                
                ML4WButton { 
                    text: "Welcome"
                    onClicked: {
                        root.isOpen = false
                        Quickshell.execDetached(["bash", "-c", "qs ipc call welcome toggle"])
                    }
                }
                ML4WButton { 
                    text: "Settings"
                    onClicked: {
                        root.isOpen = false
                        Quickshell.execDetached(["bash", "-c", "qs -p " + Quickshell.env("HOME") + "/.local/share/ml4w-dotfiles-settings/quickshell ipc call settings toggle"])
                    }
                }
                ML4WButton { 
                    text: "Hyprland"
                    visible: root.isHyprlandSettingsInstalled 
                    onClicked: {
                        root.isOpen = false
                        Quickshell.execDetached(["bash", "-c", "flatpak run com.ml4w.hyprlandsettings"])
                    }
                }
            }

            Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.primary; opacity: 0.3 }

            // --- SCROLLABLE CONTENT ---
            ScrollView {
                id: scrollView 
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentHeight: mainContentColumn.implicitHeight // Tells ScrollView how tall the inner content truly is
                clip: true

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    interactive: true
                    contentItem: Rectangle {
                        implicitWidth: 6; radius: 3; color: Theme.primary
                        opacity: parent.pressed ? 1.0 : (parent.active ? 0.8 : 0.4)
                    }
                }

                ColumnLayout {
                    id: mainContentColumn
                    width: scrollView.width
                    spacing: 20

                    // --- SLIDERS (Loudness & Brightness) ---
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 20

                        // LOUDNESS SLIDER
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 15

                            Text {
                                text: "" // Speaker icon
                                color: Theme.primary
                                font.family: "monospace"
                                font.pixelSize: 18
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Slider {
                                id: volumeSlider
                                Layout.fillWidth: true
                                from: 0
                                to: 100
                                value: 50 // Default

                                Process {
                                    command: ["bash", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'"]
                                    running: root.isOpen
                                    stdout: StdioCollector {
                                        onStreamFinished: {
                                            let val = parseInt(this.text.trim())
                                            if (!isNaN(val)) volumeSlider.value = val;
                                        }
                                    }
                                }

                                onMoved: {
                                    Quickshell.execDetached(["bash", "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ " + Math.round(value) + "%"])
                                }

                                background: Rectangle {
                                    x: volumeSlider.leftPadding
                                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 200
                                    implicitHeight: 6
                                    width: volumeSlider.availableWidth
                                    height: implicitHeight
                                    radius: 3
                                    color: Theme.background
                                    border.color: Theme.primary
                                    border.width: 1

                                    Rectangle {
                                        width: volumeSlider.visualPosition * parent.width
                                        height: parent.height
                                        color: Theme.primary
                                        radius: 3
                                    }
                                }

                                handle: Rectangle {
                                    x: volumeSlider.leftPadding + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                                    y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    radius: 8
                                    color: volumeSlider.pressed ? Theme.background : Theme.primary
                                    border.color: Theme.primary
                                    border.width: 1
                                }
                            }
                        }

                        // BRIGHTNESS SLIDER
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 15

                            Text {
                                text: "" // Sun/Brightness icon
                                color: Theme.primary
                                font.family: "monospace"
                                font.pixelSize: 18
                                Layout.alignment: Qt.AlignVCenter
                            }

                            Slider {
                                id: brightnessSlider
                                Layout.fillWidth: true
                                from: 10 // Guaranteed Minimum 10%
                                to: 100
                                value: 100

                                Process {
                                    command: ["bash", "-c", "brightnessctl -m | awk -F, '{gsub(\"%\",\"\",$4); print $4}'"]
                                    running: root.isOpen
                                    stdout: StdioCollector {
                                        onStreamFinished: {
                                            let val = parseInt(this.text.trim())
                                            if (!isNaN(val)) brightnessSlider.value = Math.max(10, val);
                                        }
                                    }
                                }

                                onMoved: {
                                    Quickshell.execDetached(["bash", "-c", "brightnessctl set " + Math.round(value) + "%"])
                                }

                                background: Rectangle {
                                    x: brightnessSlider.leftPadding
                                    y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 200
                                    implicitHeight: 6
                                    width: brightnessSlider.availableWidth
                                    height: implicitHeight
                                    radius: 3
                                    color: Theme.background
                                    border.color: Theme.primary
                                    border.width: 1

                                    Rectangle {
                                        width: brightnessSlider.visualPosition * parent.width
                                        height: parent.height
                                        color: Theme.primary
                                        radius: 3
                                    }
                                }

                                handle: Rectangle {
                                    x: brightnessSlider.leftPadding + brightnessSlider.visualPosition * (brightnessSlider.availableWidth - width)
                                    y: brightnessSlider.topPadding + brightnessSlider.availableHeight / 2 - height / 2
                                    implicitWidth: 16
                                    implicitHeight: 16
                                    radius: 8
                                    color: brightnessSlider.pressed ? Theme.background : Theme.primary
                                    border.color: Theme.primary
                                    border.width: 1
                                }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.primary; opacity: 0.3; Layout.topMargin: 5; Layout.bottomMargin: 5 }

                    // --- MPRIS PLAYERS (Scrollable ListView) ---
                    ListView {
                        id: mprisListView
                        Layout.fillWidth: true
                        
                        // Dynamically scale based on players, up to 210px (max 2 players)
                        Layout.preferredHeight: contentHeight
                        Layout.maximumHeight: 210
                        
                        spacing: 10
                        clip: true
                        
                        model: Mpris.players.values
                        visible: Mpris.players.values.length > 0

                        // Force disable scrolling entirely unless there are 3+ players
                        interactive: mprisListView.count > 2

                        ScrollBar.vertical: ScrollBar {
                            // Explicitly hide the scrollbar unless there are 3+ players
                            policy: mprisListView.count > 2 ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
                            interactive: true
                            contentItem: Rectangle {
                                implicitWidth: 6; radius: 3; color: Theme.primary
                                opacity: parent.pressed ? 1.0 : (parent.active ? 0.8 : 0.4)
                            }
                        }

                        delegate: Rectangle {
                            id: playerCard
                            property var player: modelData

                            width: mprisListView.width - 16
                            implicitHeight: 100
                            
                            radius: 10
                            color: Theme.background
                            border.color: Theme.primary
                            border.width: 1
                            clip: true

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 15

                                // Cover Art Block
                                Rectangle {
                                    implicitWidth: 80
                                    implicitHeight: 80
                                    radius: 8
                                    color: "transparent"
                                    border.color: Theme.primary
                                    border.width: 1
                                    clip: true
                                    
                                    Image {
                                        anchors.fill: parent
                                        source: player.trackArtUrl ? player.trackArtUrl : ""
                                        fillMode: Image.PreserveAspectCrop
                                        visible: player.trackArtUrl !== ""
                                    }
                                    Text {
                                        anchors.centerIn: parent
                                        text: "󰝚" // Music note icon (fallback)
                                        font.family: "monospace"
                                        font.pixelSize: 32
                                        color: Theme.primary
                                        visible: !player.trackArtUrl || player.trackArtUrl === ""
                                    }
                                }

                                // Track Info & Controls
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    spacing: 5

                                    Text {
                                        Layout.fillWidth: true
                                        text: player.trackTitle ? player.trackTitle : (player.identity ? player.identity : "No Media Playing")
                                        color: Theme.primary
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 16
                                        font.bold: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: {
                                            if (player.trackArtist) return player.trackArtist;
                                            if (player.trackArtists && player.trackArtists.length > 0) return player.trackArtists[0];
                                            return "Unknown Artist";
                                        }
                                        color: Theme.on_background
                                        font.family: Theme.fontFamily
                                        font.pixelSize: 13
                                        elide: Text.ElideRight
                                        opacity: 0.8
                                    }

                                    Item { Layout.fillHeight: true } 

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 15
                                        
                                        Item { Layout.fillWidth: true } 

                                        ActionIcon {
                                            iconTxt: "󰒮" 
                                            implicitWidth: 32
                                            implicitHeight: 32
                                            onClicked: player.previous()
                                        }

                                        ActionIcon {
                                            iconTxt: player.isPlaying ? "󰏤" : "󰐊" 
                                            implicitWidth: 32
                                            implicitHeight: 32
                                            onClicked: player.isPlaying = !player.isPlaying 
                                        }

                                        ActionIcon {
                                            iconTxt: "󰒭" 
                                            implicitWidth: 32
                                            implicitHeight: 32
                                            onClicked: player.next()
                                        }
                                        
                                        Item { Layout.fillWidth: true }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle { 
                        Layout.fillWidth: true; 
                        implicitHeight: 1; 
                        color: Theme.primary; 
                        opacity: 0.3; 
                        Layout.topMargin: 5; 
                        Layout.bottomMargin: 5;
                        visible: Mpris.players.values.length > 0 
                    }

                    // --- WAYBAR ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Waybar"; color: Theme.on_background; font.family: Theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true } 
                        ML4WSwitch { 
                            id: waybarSwitch
                            property bool ready: false
                            Process {
                                command: ["bash", "-c", "test -f ~/.config/ml4w/settings/waybar-disabled && echo 0 || echo 1"]
                                running: root.isOpen 
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        console.log("Test for Waybar: " + this.text.trim())
                                        waybarSwitch.checked = (this.text.trim() === "1")
                                        waybarSwitch.ready = true
                                    }
                                }
                            }
                            onClicked: {
                                if (!ready) return;
                                let fileCmd = checked 
                                ? "rm -f ~/.config/ml4w/settings/waybar-disabled"
                                : "touch ~/.config/ml4w/settings/waybar-disabled"       
                                console.log("Waybar cmd: " + fileCmd)
                                Quickshell.execDetached(["bash", "-c", fileCmd + ";" + Quickshell.env("HOME") + "/.config/waybar/launch.sh"])
                            }
                        }

                        SettingsWheel {
                            onClicked: waybarMenu.open()
                            Menu {
                                id: waybarMenu
                                y: parent.height
                                implicitWidth: 220
                                padding: 8
                                
                                background: Rectangle { color: Theme.background; border.color: Theme.primary; border.width: 1; radius: 8 }
                                ML4WMenuItem { text: "Select Waybar Theme"; onClicked: {
                                        Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/waybar/themeswitcher.sh"])
                                    }
                                }
                                ML4WMenuItem { text: "Edit Quicklinks"; onClicked: {
                                        root.isOpen = false
                                        Quickshell.execDetached(["gnome-text-editor", Quickshell.env("HOME") + "/.config/ml4w/settings/waybar-quicklinks.json"])
                                    }
                                }
                                ML4WMenuItem { text: "Reload Waybar"; onClicked: {
                                        Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/waybar/launch.sh"])
                                    } 
                                }
                            }
                        }
                    }

                    // --- DOCK ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Dock"; color: Theme.on_background; font.family: Theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true }
                        ML4WSwitch { 
                            id: dockSwitch
                            property bool ready: false
                            Process {
                                command: ["bash", "-c", "test -f ~/.config/ml4w/settings/dock-disabled && echo 0 || echo 1"]
                                running: root.isOpen 
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        console.log("Test for Dock: " + this.text.trim())
                                        dockSwitch.checked = (this.text.trim() === "1")
                                        dockSwitch.ready = true
                                    }
                                }
                            }
                            onClicked: {
                                if (!ready) return;
                                let fileCmd = checked 
                                ? "rm -f ~/.config/ml4w/settings/dock-disabled"
                                : "touch ~/.config/ml4w/settings/dock-disabled"
                                console.log("Dock cmd: " + fileCmd)
                                Quickshell.execDetached(["bash", "-c", fileCmd + "; " + Quickshell.env("HOME") + "/.config/nwg-dock-hyprland/launch.sh"])
                            }
                        }
                        Item { implicitWidth: 28 } 
                    }

                    // --- GAMEMODE ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Gamemode"; color: Theme.on_background; font.family: Theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true }
                        ML4WSwitch { 
                            id: gamemodeSwitch
                            property bool ready: false
                            Process {
                                command: ["bash", "-c", "test -f ~/.config/ml4w/settings/gamemode-enabled && echo 0 || echo 1"]
                                running: root.isOpen 
                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        console.log("Test for Gamemode: " + this.text.trim())
                                        gamemodeSwitch.checked = (this.text.trim() === "0")
                                        gamemodeSwitch.ready = true
                                    }
                                }
                            }
                            onClicked: {
                                if (!ready) return;
                                Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/gamemode.sh"])
                            }
                        }
                        Item { implicitWidth: 28 } 
                    }

                    // --- SIDEPAD ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Sidepad"; color: Theme.on_background; font.family: Theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true }
                        ML4WSwitch { 
                            id: sidepadSwitch
                            onClicked: {
                                if (checked) {
                                    console.log("Launching sidebar...")
                                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-sidepad --init"])
                                } else {
                                    console.log("Stopping sidebar...")
                                    Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-sidepad --kill"])
                                }
                            }
                        }
                        SettingsWheel {
                            onClicked: sidepadMenu.open()
                            Menu {
                                id: sidepadMenu
                                y: parent.height
                                
                                implicitWidth: 220
                                padding: 8
                                
                                background: Rectangle { color: Theme.background; border.color: Theme.primary; border.width: 1; radius: 8 }
                                ML4WMenuItem { text: "Select Sidepad"; onClicked: {
                                        Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-sidepad --select"])
                                    } 
                                }
                                ML4WMenuItem { text: "Open Sidepad Folder"; onClicked: {
                                        Quickshell.execDetached(["nautilus", Quickshell.env("HOME") + "/.config/sidepad/pads"])
                                    } 
                                }
                            }
                        }
                    }

                    Rectangle { Layout.fillWidth: true; implicitHeight: 1; color: Theme.primary; opacity: 0.3; Layout.topMargin: 5; Layout.bottomMargin: 5 }

                    // --- WALLPAPER ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Wallpaper"; color: Theme.on_background; font.family: Theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true }
                        ActionIcon { 
                            iconTxt: ""
                            onClicked: {
                                root.isOpen = false
                                Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/scripts/ml4w-wallpaper-app"])
                            }
                        }
                    }

                    // --- THEME ---
                    RowLayout {
                        Layout.fillWidth: true
                        Text { text: "Theme"; color: Theme.on_background; font.family: Theme.fontFamily; font.pixelSize: 16 }
                        Item { Layout.fillWidth: true }
                        ActionIcon { 
                            iconTxt: ""
                            onClicked: {
                                root.isOpen = false
                                Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/ml4w/themes/themes.sh"])
                            }
                        }
                        SettingsWheel {
                            onClicked: themeMenu.open()
                            Menu {
                                id: themeMenu
                                y: parent.height
                                
                                implicitWidth: 220
                                padding: 8
                                
                                background: Rectangle { color: Theme.background; border.color: Theme.primary; border.width: 1; radius: 8 }
                                ML4WMenuItem { text: "Set GTK Theme"; onClicked: {
                                        root.isOpen = false
                                        Quickshell.execDetached(["nwg-look"])
                                    } 
                                }
                                ML4WMenuItem { text: "Set QT Theme"; onClicked: {
                                        root.isOpen = false
                                        Quickshell.execDetached(["qt6ct"])
                                    }
                                }
                                ML4WMenuItem { text: "Refresh GTK Theme"; onClicked: {
                                        root.isOpen = false
                                        Quickshell.execDetached(["bash", "-c", Quickshell.env("HOME") + "/.config/hypr/scripts/gtk.sh"])
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