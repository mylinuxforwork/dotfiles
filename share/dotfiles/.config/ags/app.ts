import { App, Widget } from "astal/gtk3"
import Calendar from "./widget/Calendar"
import Sidebar from "./widget/Sidebar"

App.start({
    css: "./style.css",
    main() {
        Sidebar();
        Calendar();
    }
})
