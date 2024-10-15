# ------------------------------------------------------
# Set KVM environment variables
# ------------------------------------------------------

_install_vm() {
    if grep -Fxq "kvm.conf" $ml4w_directory/$version/.config/hypr/conf/environment.conf
    then
        echo ":: KVM Environment already set."
    else
        if gum confirm "Do you want to install the KVM environment variables?" ;then
            echo "source = ~/.config/hypr/conf/environments/kvm.conf" >  $ml4w_directory/$version/.config/hypr/conf/environment.conf
            echo "Environment set to KVM."
        fi
    fi
    if [[ $(_isInstalledPacman "qemu-guest-agent") == 0 ]]; then
        echo ":: Qemu Guest Agent already installed"
    else
        if gum confirm "Do you want to install the QEMU guest agent?" ;then
            _installPackagesPacman "qemu-guest-agent";
        fi
    fi
}

if [[ $(_check_update) == "false" ]] ;then
    if [ $(_isKVM) == "0" ] ;then
        echo -e "${GREEN}"
        figlet -f smslant "KVM VM"
        echo -e "${NONE}"
        if [ -z $automation_vm ] ;then
            echo "The script has detected that you run the installation in a KVM virtual machine."
            echo
            _install_vm
        else
            if [[ "$automation_vm" = false ]] ;then
                echo ":: AUTOMATION: VM Support skipped"
                echo
            elif [[ "$automation_vm" = true ]] ;then
                _install_vm
            else
                echo ":: AUTOMATION ERROR: VM Support"
            fi        
        fi
    fi
fi
