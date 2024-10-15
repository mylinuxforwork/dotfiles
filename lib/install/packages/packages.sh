# ------------------------------------------------------
# Install packages
# ------------------------------------------------------

if [[ $install_mode == "filesystem" ]] ;then
    echo -e "${GREEN}"
    if [ -x figlet ] ;then
        figlet -f smslant "Packages"
    else
        cat <<"        EOF"
   ___           __                   
  / _ \___ _____/ /_____ ____ ____ ___
 / ___/ _ `/ __/  '_/ _ `/ _ `/ -_|_-<
/_/   \_,_/\__/_/\_\\_,_/\_, /\__/___/
                        /___/         
        EOF
    fi
    echo -e "${NONE}"

    # General packages
    source $packages_directory/general.sh
    _installPackagesPacman "${packagesPacman[@]}";
    _installPackagesAUR "${packagesAUR[@]}";

    echo -e "${GREEN}"
    figlet -f smslant "Hyprland"
    echo -e "${NONE}"
    source $packages_directory/hyprland.sh
    _installPackagesPacman "${packagesPacman[@]}";
    _installPackagesAUR "${packagesAUR[@]}";
fi