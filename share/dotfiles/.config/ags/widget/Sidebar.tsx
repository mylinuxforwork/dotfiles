import { App } from "astal/gtk3"
import Apps from "gi://AstalApps"
import Wp from "gi://AstalWp"
import { Variable, GLib, bind } from "astal"
import { subprocess, exec, execAsync } from "astal/process"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Brightness from "./Brightness"

function BrightnessSlider() {
    const brightness = Brightness.get_default()

    return <box className="MicrophoneSlider" css="min-width: 140px">
        <slider
            hexpand
            value={bind(brightness, "screen")}
            onDragged={({ value }) => brightness.screen = value}
        />
    </box>
}

function AudioSlider() {
    const speaker = Wp.get_default()?.audio.defaultSpeaker!

    return <box className="AudioSlider" css="min-width: 140px">
        <slider
            hexpand
            onDragged={({ value }) => speaker.volume = value}
            value={bind(speaker, "volume")}
        />
    </box>
}

function MicrophoneSlider() {
    const microphone = Wp.get_default()?.audio.defaultMicrophone!

    return <box className="MicrophoneSlider" css="min-width: 140px">
        <slider
            hexpand
            onDragged={({ value }) => microphone.volume = value}
            value={bind(microphone, "volume")}
        />
    </box>
}

function openwelcomeapp() {
    execAsync("com.ml4w.welcome")
    App.get_window("sidebar")!.hide()
}

function opensettingsapp() {
    execAsync("com.ml4w.dotfilessettings")
    App.get_window("sidebar")!.hide()
}

function openhyprlandapp() {
    execAsync("com.ml4w.hyprland.settings")
    App.get_window("sidebar")!.hide()
}

function openwaypaper() {
    const proc = subprocess(["bash", "-c", "waypaper"])    
    App.get_window("sidebar")!.hide()
}

function openwallpapereffects() {
    const proc = subprocess(["bash", "-c", "$HOME/.config/hypr/scripts/wallpaper-effects.sh"])    
    App.get_window("sidebar")!.hide()
}

function openwaybarthemes() {
    const proc = subprocess(["bash", "-c", "$HOME/.config/waybar/themeswitcher.sh"])    
    App.get_window("sidebar")!.hide()
}

export default function Sidebar() {

    const anchor = Astal.WindowAnchor.TOP
        | Astal.WindowAnchor.RIGHT

    return <window 
    name="sidebar"
    application={App}
    visible={false} 
    className="Sidebar"
    anchor={anchor}
    keymode={Astal.Keymode.ON_DEMAND}
    onKeyPressEvent={function (self, event: Gdk.Event) {
        if (event.get_keyval()[1] === Gdk.KEY_Escape)
            self.hide()
    }}      
    >    
    <box className="sidebar" vertical>
        <box css="padding-bottom:20px;">
            <box className="group" vertical>
                <box homogeneous>
                    <button onClicked={openwelcomeapp} className="ml4wwelcomeicon"></button>
                    <button onClicked={opensettingsapp} className="ml4wsettingsicon"></button>
                    <button onClicked={openhyprlandapp} className="ml4whyprlandicon"></button>
                </box>
                <box homogeneous>
                    <button onClicked={openwelcomeapp}>Welcome App</button>
                    <button onClicked={opensettingsapp}>Settings App</button>
                    <button onClicked={openhyprlandapp}>Hyprland App</button>
                </box>
            </box>
        </box>
        <box css="padding-bottom:20px;">
            <box className="group" hexpand vertical>
                <box spacing="20" css="padding-bottom:20px;" homogeneous>
                    <button onClicked={openwaypaper} className="midbtn">Wallpapers</button>
                    <button onClicked={openwallpapereffects} className="midbtn">Effects</button>
                </box>
                <box homogeneous>
                    <button onClicked={openwaybarthemes} className="midbtn">Status Bar Themes</button>
                </box>
            </box>
        </box>
        <box className="group" halign="left" vertical>
            <label css="padding-bottom:10px" label="Speaker"></label>
            <AudioSlider/>
            <label css="padding-bottom:10px" label="Microphone"></label>
            <MicrophoneSlider />
        </box>
        <box css="padding-bottom:20px;"></box>
        <box className="group" halign="left" vertical>
            <label css="padding-bottom:10px" label="Brightness"></label>
            <BrightnessSlider />
        </box>
    </box>
</window>
}