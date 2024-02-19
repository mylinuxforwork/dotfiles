# Set KVM environment variables
if [ $(_isKVM) == "0" ] ;then
echo -e "${GREEN}"
figlet "KVM VM"
echo -e "${NONE}"
    echo "The script has detected that you run the installation in a KVM virtual machine."
    if grep -Fxq "kvm.conf" ~/dotfiles-versions/$version/hypr/conf/environment.conf
    then
        echo ":: KVM Environment already set."
    else
        if gum confirm "Do you want to install the KVM environment variables?" ;then
            echo "source = ~/dotfiles/hypr/conf/environments/kvm.conf" >  ~/dotfiles-versions/$version/hypr/conf/environment.conf
            echo "Environment set to KVM."
        fi
    fi
    if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
        echo ":: Qemu Guest Agent already installed"
    else
        if gum confirm "Do you want to install the QEMU guest agent?" ;then
            _installPackagesPacman "qemu-guest-agent";
        fi
    fi
fi
