if [[ "$automation_vm" = false ]] ;then
    echo ":: AUTOMATION: VM Support skipped"
    echo
elif [[ "$automation_vm" = true ]] ;then
    echo -e "${GREEN}"
    figlet "KVM VM"
    echo -e "${NONE}"
    if [ $(_isKVM) == "0" ] ;then
        if grep -Fxq "kvm.conf" ~/dotfiles-versions/$version/.config/hypr/conf/environment.conf ;then
            echo ":: AUTOMATION: KVM Environment already set."
        else
            echo "source = ~/.config/hypr/conf/environments/kvm.conf" >  ~/dotfiles-versions/$version/.config/hypr/conf/environment.conf
            echo ":: AUTOMATION: Environment set to KVM."
        fi
        _installPackagesPacman "qemu-guest-agent";
    else
        echo ":: AUTOMATION: No KVM VM detected"
        echo
    fi
else
    echo ":: AUTOMATION ERROR: VM Support"
fi