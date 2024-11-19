import { GObject } from "astal";
import { astalify, ConstructProps, App, Astal, Gdk, Gtk } from "astal/gtk3"

class CalendarGtk extends astalify(Gtk.Calendar) {
	static {
		GObject.registerClass(this);
	}

	constructor(
		props: ConstructProps<Gtk.Calendar, Gtk.Calendar.ConstructorProps>,
	) {
		super(props as any);
	}
}

export default function Calendar() {
    const anchor = Astal.WindowAnchor.TOP
        | Astal.WindowAnchor.RIGHT

    return <window 
    name="calendar"
    visible={false} 
    application={App}
    anchor={anchor}
    >
    <box 
    className="calendar"
    >{new CalendarGtk({ 
        hexpand: true, 
        vexpand: true,
        showDayNames: true,
        showDetails: false,
        showHeading: true,
        showWeekNumbers: true
    })}</box>
</window>
}
