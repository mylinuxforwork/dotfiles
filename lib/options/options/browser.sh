#!/bin/bash
clear
echo -e "${GREEN}"
figlet -f smslant "Browser"
echo -e "${NONE}"
source $packages_directory/$install_platform/options/browser.sh
toInstall=""
selectedInstall=""

_checkPackages
_checkDefault "browser.sh"

_updateWaybarBrowserQuicklink() {
    local new_icon="$1"
    local new_name="$2"

    local waybar_ql="$HOME/.config/ml4w/settings/waybar-quicklinks.json"
    local browser_sh="~/.config/ml4w/settings/browser.sh"

    if [ -f "$waybar_ql" ]; then
        local quicklink
        quicklink=$(grep -m1 -B 2 "$browser_sh" "$waybar_ql" \
                      | grep -oE '"custom/[^"]+":' \
                      | head -n1 \
                      | tr -d '":')
        if [ -n "$quicklink" ]; then
            local escaped_quicklink=$(printf '%s' "$quicklink" | sed 's/\//\\\//g')

            _updateQuicklinkProperty() {
                local property="$1"
                local new_value="$2"
                sed -i.bak -E "/\"$escaped_quicklink\": *\{/,/^\s*\}/ s|([[:space:]]*\"$property\"[[:space:]]*:[[:space:]]*\").*(\")|\1$new_value\2|" "$waybar_ql"
                rm -f "$waybar_ql.bak"
            }

            _updateQuicklinkProperty "format" "$new_icon"
            [ -z "$new_name" ] && new_name="Browser"
            _updateQuicklinkProperty "tooltip-format" "Open $new_name"

            unset -f _updateQuicklinkProperty
        else
            echo "No waybar quicklink found for '$browser_sh'"
            sleep 1
        fi
    else
        echo "No waybar-quicklinks.json file found"
        sleep 1
    fi
}


optionalSelect=$(gum choose $toInstall "CANCEL")
if [ -z "$optionalSelect" ] || [ "$optionalSelect" = "CANCEL" ]; then
    if [ -z "$options_argument" ]; then
        _selectCategory
    else
        exit
    fi
else
    if [[ ! $(_isInstalled "$optionalSelect") == 0 ]]; then
        _installPackage $optionalSelect
    fi
    
    case $optionalSelect in
        firefox)
            echo 'firefox' > "$HOME/.config/ml4w/settings/browser.sh"
            _updateWaybarBrowserQuicklink "" "Firefox"
            break
            ;;
        chromium)
            echo 'chromium' > "$HOME/.config/ml4w/settings/browser.sh"
            _updateWaybarBrowserQuicklink "" "Chromium"
            break
            ;;
        brave|brave-bin|brave-browser)
            echo 'brave' > "$HOME/.config/ml4w/settings/browser.sh"
            _updateWaybarBrowserQuicklink "" "Brave"
            break
            ;;
        zen-browser-bin|zen-browser)
            echo 'zen-browser' > "$HOME/.config/ml4w/settings/browser.sh"
            _updateWaybarBrowserQuicklink "" "Zen Browser"
            break
            ;;
        *)
            echo "$optionalSelect" > "$HOME/.config/ml4w/settings/browser.sh"
            _updateWaybarBrowserQuicklink "" "Browser"
            break
            ;;
    esac
    
    _selectCategory
fi
