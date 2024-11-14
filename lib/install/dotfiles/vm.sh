# ------------------------------------------------------
# Set KVM environment variables
# ------------------------------------------------------
_writeLogHeader "KVM VM"

_install_vm() {
    if grep -Fxq "kvm.conf" $ml4w_directory/$version/.config/hypr/conf/environment.conf
    then
        echo ":: KVM Environment already set."
    else
        if gum confirm "Do you want to install the KVM environment variables?" ;then
            echo "source = ~/.config/hypr/conf/environments/kvm.conf" >  $ml4w_directory/$version/.config/hypr/conf/environment.conf
            _writeLogTerminal 1 "Environment set to KVM."
        fi
    fi
    if [[ $(_isInstalled "qemu-guest-agent") == 0 ]]; then
       _writeLog 0 "Qemu Guest Agent already installed"
    else
        if gum confirm "Do you want to install the QEMU guest agent?" ;then
            _installPackages "qemu-guest-agent";
        fi
    fi
}

if [[ $(_check_update) == "false" ]] ;then
    if [ $(_isKVM) == "0" ] ;then
        _writeHeader "KVM VM"
        if [ -z $automation_vm ] ;then
            _writeLogTerminal 0 "The script has detected that you run the installation in a KVM virtual machine."
            echo
            _install_vm
        else
            if [[ "$automation_vm" = false ]] ;then
                _writeSkipped
                echo
            elif [[ "$automation_vm" = true ]] ;then
                _install_vm
            else
                _writeLog 2 "AUTOMATION ERROR: VM Support"
            fi        
        fi
    fi
fi
