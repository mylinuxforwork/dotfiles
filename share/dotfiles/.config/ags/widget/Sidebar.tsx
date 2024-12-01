import { App } from "astal/gtk3"
import Apps from "gi://AstalApps"
import Wp from "gi://AstalWp"
import { Variable, GLib, bind, exec, execAsync } from "astal"
import { Astal, Gtk, Gdk } from "astal/gtk3"
import Mpris from "gi://AstalMpris"

// taking length
function lengthStr(length: number) {
    const min = Math.floor(length / 60)
    const sec = Math.floor(length % 60)
    const sec0 = sec < 10 ? "0" : ""
    return `${min}:${sec0}${sec}`
}

// used mrpis
function MediaPlayer({ player }: { player: Mpris.Player }) {
    const { START, END } = Gtk.Align

    const title = bind(player, "title").as(t =>
        t || "Unknown Track")

    const artist = bind(player, "artist").as(a =>
        a || "Unknown Artist")

    const coverArt = bind(player, "coverArt").as(c =>
        `background-image: url('${c}')`)

        const validateEntry = (entry: string | null | undefined) => {
            return entry && Astal.Icon.lookup_icon(entry) ? entry : "audio-x-generic-symbolic";
        };
        
        const playerIcon = bind(player, "entry").as(validateEntry);
        
        

    const position = bind(player, "position").as(p => player.length > 0
        ? p / player.length : 0)

    const playIcon = bind(player, "playbackStatus").as(s =>
        s === Mpris.PlaybackStatus.PLAYING
            ? "media-playback-pause-symbolic"
            : "media-playback-start-symbolic"
    )

    return <box className="MediaPlayer">
        <box className="cover-art" css={coverArt} />
        <box className="hi" vertical>
            <box className="title">
                <label truncate hexpand halign={START} label={title} />
                <icon icon={playerIcon} />
            </box>
            <label halign={START} valign={START} vexpand wrap label={artist} />
            <slider
                visible={bind(player, "length").as(l => l > 0)}
                onDragged={({ value }) => player.position = value * player.length}
                value={position}
            />
            <centerbox className="actions">
                <label
                    hexpand
                    className="position"
                    halign={START}
                    visible={bind(player, "length").as(l => l > 0)}
                    label={bind(player, "position").as(lengthStr)}
                />
                <box>
                    <button
                    css={"padding-right: 15px"}
                        onClicked={() => player.previous()}
                        visible={bind(player, "canGoPrevious")}>
                        <icon icon="media-skip-backward-symbolic" />
                    </button>
                    <button
                        onClicked={() => player.play_pause()}
                        visible={bind(player, "canControl")}>
                        <icon icon={playIcon} />
                    </button>
                    <button
                    css={"padding-left: 15px"}
                        onClicked={() => player.next()}
                        visible={bind(player, "canGoNext")}>
                        <icon icon="media-skip-forward-symbolic" />
                    </button>
                </box>
                <label
                    hexpand
                    className="length"
                    halign={END}
                    visible={bind(player, "length").as(l => l > 0)}
                    label={bind(player, "length").as(l => l > 0 ? lengthStr(l) : "0:00")}
                />
            </centerbox>
        </box>
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
    execAsync("waypaper")
    App.get_window("sidebar")!.hide()
}

function openwallpapereffects() {
    execAsync("./scripts/run_wallpapereffects.sh")
    App.get_window("sidebar")!.hide()
}

function openwaybarthemes() {
    execAsync("./scripts/run_themeswitcher.sh")
    App.get_window("sidebar")!.hide()
}

export default function Sidebar() {
    const mpris = Mpris.get_default()
    const anchor = Astal.WindowAnchor.TOP
        | Astal.WindowAnchor.RIGHT

    return <window 
    name="sidebar"
    application={App}
    visible={false} 
    className="Sidebar"
    anchor={anchor}
    >    
    <box className="sidebar" vertical>

{/* you can just cut the lines 169-180 and paste it according to your need of postion in the sidebar */}

    {bind(mpris, "players").as(arr => {
        const lastPlayer = arr[arr.length - 1]; // Get the last index of the array (you will get alot of players, the last one has all the metadata of the current playing song)
        if(lastPlayer === undefined){
            return <></>
        } else {
            return (
                <box css={"margin-bottom: 20px"} halign="left" vertical>
                <MediaPlayer player={lastPlayer} />
            </box>
        )}
})}

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
        
    </box>
</window>
}
