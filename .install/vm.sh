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
    if gum confirm "Are you running this script in a KVM virtual machine?" ;then
        echo "source = ~/dotfiles/hypr/conf/environments/kvm.conf" >  ~/dotfiles-versions/$version/hypr/conf/environment.conf
        echo "Environment set to KVM."
    fi
fi
