//  ____  _     _      _                
// / ___|(_) __| | ___| |__   __ _ _ __ 
// \___ \| |/ _` |/ _ \ '_ \ / _` | '__|
//  ___) | | (_| |  __/ |_) | (_| | |   
// |____/|_|\__,_|\___|_.__/ \__,_|_|   
//                                      

import GLib from "gi://GLib?version=2.0"

// Set App icons
App.addIcons(`${App.configDir}/assets`)

// Get current username to generate absolute paths
const username = GLib.get_user_name()
const divide = ([total, free]) => free / total

// Get current time
const date = Variable("", {
    poll: [1000, 'date "+%H:%M:%S %b %e."'],
})

// Get CPU information
const cpu = Variable(0, {
    poll: [2000, 'top -b -n 1', out => divide([100, out.split('\n')
        .find(line => line.includes('Cpu(s)'))
        .split(/\s+/)[1]
        .replace(',', '.')])],
})

const cpuval = Variable(0, {
    poll: [2000, 'top -b -n 1', out => Math.round(divide([100, out.split('\n')
        .find(line => line.includes('Cpu(s)'))
        .split(/\s+/)[1]
        .replace(',', '.')])*100).toString() + "%"],
})

// Get RAM information
const ram = Variable(0, {
    poll: [2000, 'free', out => divide(out.split('\n')
        .find(line => line.includes('Mem:'))
        .split(/\s+/)
        .splice(1, 2))],
})

const ramval = Variable(0, {
    poll: [2000, 'free', out => Math.round(divide(out.split('\n')
        .find(line => line.includes('Mem:'))
        .split(/\s+/)
        .splice(1, 2))*100).toString() + "%"],
})

// Calendar Widget
const cld = Widget.Calendar({
    showDayNames: true,
    showDetails: false,
    showHeading: true,
    showWeekNumbers: true,
    className:"cld"
})

// ML4W Welcome Button
const ml4wWelcomeBox = Widget.Box({
    vertical: true,
    children: [
        Widget.Button({
            className:"ml4wwelcomeicon",
            onClicked: () => {
                print(':: Start Welcome App')
                Utils.subprocess('com.ml4w.welcome')
                App.closeWindow("sidebar")
            }
        }),
        Widget.Button({
            className: "btn",
            child: Widget.Label('Welcome App'),
            onClicked: () => {
                print(':: Start Welcome App')
                Utils.subprocess('com.ml4w.welcome')
                App.closeWindow("sidebar")
            }
        })
    ]
})

// ML4W Dotfiles Settings Button
const ml4wSettingsBox = Widget.Box({
    vertical: true,
    children: [
        Widget.Button({
            className:"ml4wsettingsicon",
            onClicked: () => {
                print(':: Start Settings App')
                Utils.subprocess('com.ml4w.dotfilessettings')
                App.closeWindow("sidebar")
            }
        }),
        Widget.Button({
            className: "btn",
            child: Widget.Label('Settings App'),
            onClicked: () => {
                print(':: Start Settings App')
                Utils.subprocess('com.ml4w.dotfilessettings')
                App.closeWindow("sidebar")
            }
        })
    ]
})

// ML4W Hyprland Settings Button
const ml4wHyprlandBox = Widget.Box({
    vertical: true,
    children: [
        Widget.Button({
            className:"ml4whyprlandicon",
            onClicked: () => { 
                print(':: Start Hyprland App')
                Utils.subprocess('com.ml4w.hyprland.settings')
                App.closeWindow("sidebar")
            }
        }),
        Widget.Button({
            className: "btn",
            child: Widget.Label('Hyprland App'),
            onClicked: () => { 
                print(':: Start Hyprland App')
                Utils.subprocess('com.ml4w.hyprland.settings')
                App.closeWindow("sidebar")
            }
        })
    ]
})

// CPU Widget
const cpuProgress = Widget.CircularProgress({
    className: "circularprocess",
    value: cpu.bind(),
    child: Widget.Label({
        label:cpuval.bind()
    })
})

const cpuProgressBox = Widget.Box({
    vertical: true,
    children: [
        cpuProgress,
        Widget.Label({
            className: "circularlabel",
            label: "CPU"
        })
    ]
})

// RAM Widget
const ramProgress = Widget.CircularProgress({
    className: "circularprocess",
    value: ram.bind(),
    child: Widget.Label({
        label:ramval.bind()
    })
})

const ramProgressBox = Widget.Box({
    vertical: true,
    children: [
        ramProgress,
        Widget.Label({
            className: "circularlabel",
            label: "RAM"
        })
    ]
})

const audio = await Service.import('audio')

/** @param {'speaker' | 'microphone'} type */
const VolumeSlider = (type = 'speaker') => Widget.Slider({
    hexpand: true,
    drawValue: false,
    onChange: ({ value }) => audio[type].volume = value,
    value: audio[type].bind('volume'),
})

const speakerSlider = VolumeSlider('speaker')
const micSlider = VolumeSlider('microphone')

const speakerBox = Widget.Box({
    vertical: true,
    spacing: 3,
    children:[
        Widget.Label({
            className: "sliderlabel",
            label: "Speaker",
            xalign: 0
        }),        
        speakerSlider
    ]
})

const micBox = Widget.Box({
    vertical: true,
    spacing: 3,
    children:[
        Widget.Label({
            className: "sliderlabel",
            label: "Mic",
            xalign: 0
        }),        
        micSlider
    ]
})

const btnWallpaper = Widget.Button({
    className: "midbtn",
    child: Widget.Label('Wallpapers'),
    onClicked: () => { 
        print(':: Start Waypaper')
        Utils.subprocess('waypaper')
        App.closeWindow("sidebar")
    }
})

const btnWallpaperEffects = Widget.Button({
    className: "midbtn",
    child: Widget.Label('Effects'),
    onClicked: () => { 
        print(':: Start Wallpaper Effects')
        Utils.subprocess(App.configDir + '/scripts/run_wallpapereffects.sh')
        App.closeWindow("sidebar")
    }
})

const btnWaybarThemes = Widget.Button({
    className: "midbtn",
    child: Widget.Label('Status Bar Themes'),
    onClicked: () => { 
        print(':: Start Waybar Themes')
        Utils.subprocess(App.configDir + '/scripts/run_themeswitcher.sh')
        App.closeWindow("sidebar")
    }
})

// Sidebar Box
const Sidebar = Widget.Box({
    spacing: 16,
    vertical: true,
    className: "sidebar",
    children: [
        Widget.Box({
            className: "group",
            homogeneous: true,
            children:[
                Widget.Box({
                    className: "row",
                    homogeneous: true,
                    children:[ml4wWelcomeBox,ml4wSettingsBox,ml4wHyprlandBox]
                }),
            ]
        }),
        Widget.Box({
            className: "group",
            homogeneous: false,
            vertical: true,
            spacing:10,
            children:[
                Widget.Box({
                    className: "rowsmall",
                    spacing:10,
                    homogeneous: true,
                    children:[btnWallpaper, btnWallpaperEffects]
                }),
                Widget.Box({
                    homogeneous: true,
                    children:[btnWaybarThemes]
                }),
            ]
        }),
        Widget.Box({
            className: "group",
            homogeneous: true,
            children:[
                Widget.Box({
                    className: "row",
                    homogeneous: true,
                    children:[cpuProgressBox, ramProgressBox]
                }),
            ]
        }),
        Widget.Box({
            className: "group",
            homogeneous: true,
            vertical: true,
            spacing:10,
            children:[speakerBox, micBox]
        }),
    ]
})

// Sidebar Box
const Calendar = Widget.Box({
    spacing: 8,
    vertical: true,
    className: "calendar",
    children: [
        Widget.Box({
            className: "group",
            homogeneous: true,
            children:[cld]
        })
    ]
})

// Sidebar Window
const SideBarWindow = Widget.Window({
    name: 'sidebar',
    className:"window",
    anchor: ['top', 'right'],
    // Start with hidden window, toggle with ags -t sidebar
    // visible: true,
    visible: false,
    child: Widget.Box({
        css: 'padding: 1px;',
        child: Sidebar,
    })
})

// Calendar Window
const CalendarWindow = Widget.Window({
    name: 'calendar',
    className:"window",
    anchor: ['top', 'right'],
    // Start with hidden window, toggle with ags -t sidebar
    // visible: true,
    visible: false,
    child: Widget.Box({
        css: 'padding: 1px;',
        child: Calendar,
    })
})

// App Configuration
let config = {
    style: "./style.css",
    windows: [
        SideBarWindow,
        CalendarWindow
    ],
    openWindowDelay: {
        'sidebar':100,
        'calendar':100,
    },
    closeWindowDelay: {
        'sidebar': 50,
        'calendar':50,
    },    
}

App.connect("window-toggled", (_, name, visible) => {
    if (visible && name == 'calendar') {
        const d = new Date();
        cld.select_day(d.getDate()) 
        cld.select_month(d.getMonth(),d.getFullYear()) 
    }
})

// Run AGS
App.config(config)
