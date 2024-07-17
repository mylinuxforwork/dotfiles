App.addIcons(`${App.configDir}/assets`)

const divide = ([total, free]) => free / total

const date = Variable("", {
    poll: [1000, 'date "+%H:%M:%S %b %e."'],
})

/*
const disk = Variable(0, {
    poll: [2000, '~/dotfiles/eww/scripts/sys_info.sh --disk', out => out],
})
*/

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

const cld = Widget.Calendar({
    showDayNames: true,
    showDetails: false,
    showHeading: true,
    showWeekNumbers: true,
    detail: (self, y, m, d) => {
        return `<span color="white">${y}. ${m}. ${d}.</span>`
    },
    onDaySelected: ({ date: [y, m, d] }) => {
        print(`${y}. ${m}. ${d}.`)
    },    
})

const btn_ml4w_welcome = Widget.Button({
    className: "btn",
    child: Widget.Label('Welcome App'),
    onClicked: () => print('Welcome'),
})

const btn_ml4w_settings = Widget.Button({
    className: "btn",
    child: Widget.Label('Settings App'),
    onClicked: () => print('Settings'),
})

const btn_ml4w_hyprland = Widget.Button({
    className: "btn",
    child: Widget.Label('Hyprland App'),
    onClicked: () => print('Hyprland'),
})

const cpuProgress = Widget.CircularProgress({
    className: "circularprocess",
    value: cpu.bind(),
    child: Widget.Label({
        label:cpuval.bind()
    })
})

const ramProgress = Widget.CircularProgress({
    className: "circularprocess",
    value: ram.bind(),
    child: Widget.Label({
        label:ramval.bind()
    })
})

const clock = Widget.Label({
    className: "clock",
    label: date.bind()
})

const Sidebar = Widget.Box({
    spacing: 8,
    vertical: true,
    className: "sidebar",
    children: [
        Widget.Box({
            homogeneous: true,
            spacing:8,
            children:[btn_ml4w_welcome,btn_ml4w_settings,btn_ml4w_hyprland]
        }),
        clock,
        Widget.Box({
            homogeneous: true,
            children:[cpuProgress,ramProgress]
        }),
        cld,
        Widget.Box({

        })
    ]
})

/*
const revealer = Widget.Revealer({
    revealChild: true,
    transitionDuration: 1000,
    transition: 'slide_down',
    child: Sidebar,
    setup: self => self.hook(App, (self, wname, visible) => {
        if (wname === 'sidebar')
            self.revealChild = visible
    }, 'window-toggled')
})
*/

const SideBarWindow = Widget.Window({
    name: 'sidebar',
    anchor: ['top', 'right'],
    visible: true,
    child: Widget.Box({
        css: 'padding: 1px;',
        child: Sidebar,
    })
})

let config = {
    style: "./style.css",
    windows: [
        SideBarWindow, // can be instantiated for each monitor
    ],
    closeWindowDelay: {
        'sidebar': 350,
    },    
}

App.config(config)