# Set KVM environment variables
if [ $(_isKVM) == "0" ] ;then
echo -e "${GREEN}"
cat <<"EOF"
 _  ____     ____  __  __     ____  __ 
| |/ /\ \   / /  \/  | \ \   / /  \/  |
| ' /  \ \ / /| |\/| |  \ \ / /| |\/| |
| . \   \ V / | |  | |   \ V / | |  | |
|_|\_\   \_/  |_|  |_|    \_/  |_|  |_|
                                       
EOF
echo -e "${NONE}"
    echo "The script has detected that you run the installation in a KVM virtual machine."
    if gum confirm "Do you want to install the KVM environment variables?" ;then
        echo "source = ~/dotfiles/hypr/conf/environments/kvm.conf" >  ~/dotfiles-versions/$version/hypr/conf/environment.conf
        echo "Environment set to KVM."
    fi
    if gum confirm "Do you want to install the QEMU guest agent?" ;then
        _installPackagesPacman "qemu-guest-agent";
    fi
fi
