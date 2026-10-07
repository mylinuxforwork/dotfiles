//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QPA_PLATFORMTHEME=

import "./modules/appswitcher/"
import "./services/"

import QtQuick
import Quickshell
import Quickshell.Hyprland

ShellRoot {
    Connections {
        target: Quickshell

        function onReloadCompleted() {
            Quickshell.inhibitReloadPopup();
        }
    }

    AppSwitcher {}
}
