import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';

const divide = ([total, free]) => free / total

const ram = Variable(0, {
    poll: [2000, 'free', out => divide(out.split('\n')
        .find(line => line.includes('Mem:'))
        .split(/\s+/)
        .splice(1, 2))],
})

const ramProgress = Widget.CircularProgress({
    value: ram.bind()
})

const SideBar = () => Widget.Box({
    className: 'sidebar',
    vertical: true,
    children: [ramProgress],
});

const revealer = () => Widget.Revealer({
    transition: 'slide_down',
    child: SideBar(),
}).hook(App, (self, wname, visible) => {
    if (wname === 'sidebar')
        self.revealChild = visible
}, 'window-toggled');

export default () => Widget.Window({
    name: 'sidebar',
    anchor: ["top", "right"],
    // visible: false,
    child: Widget.Box({
        css: 'padding: 1px;',
        child: revealer(),
    }),
}).keybind("Escape", (self) => App.closeWindow(self.name))