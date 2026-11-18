//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
import "WelcomeApp"
import "SidebarApp"
import "WallpaperApp"
import "StatusbarApp"
import "CustomTheme"

ShellRoot {
    // Test IPC tools: qs ipc show

    IpcHandler {
        target: "theme-manager" 
        function reload(): void {
            Theme.reloadTheme()
        }
    }
    
    Variants {
        model: Quickshell.screens

        Scope { 
        id: perScreen
        required property var modelData

        StatusbarWindow { screen: perScreen.modelData }

        }
    }

    WelcomeWindow {}
    SidebarWindow {}
    WallpaperWindow {}
    WallpaperCarousel {}
}