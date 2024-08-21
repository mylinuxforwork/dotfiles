# ------------------------------------------------------
# Helper functions for hook and post
# ------------------------------------------------------
version="ML4WVERSION"
ml4w_directory="ML4WDIRECTORY"
aur_helper="ML4WAURHELPER"

# ------------------------------------------------------
# Function: Is package installed
# ------------------------------------------------------

_checkCommandExists() {
    package="$1";
    if ! type $package > /dev/null 2>&1; then
        echo "1"
    else
        echo "0"
    fi
}

_isInstalledPacman() {
    package="$1";
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

_isInstalledAUR() {
    package="$1";
    check="$($aur_helper -Qs --color always "${package}" | grep "local" | grep "\." | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

_isInstalledYay() {
    _isInstalledAUR $1
}

_isInstalledFlatpak() {
    package="$1";
    check="$(flatpak list --columns="application" | grep "${package} ")";
    if [ -n "${check}" ] ; then
        echo 0; #'0' means 'true' in Bash
        return; #true
    fi;
    echo 1; #'1' means 'false' in Bash
    return; #false
}

# ------------------------------------------------------
# Install packages if not installed
# ------------------------------------------------------
_installPackagesPacman() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledPacman "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;

    # printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}";
}

_forcePackagesPacman() {
    toInstall=();
    for pkg; do
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All pacman packages are already installed.";
        return;
    fi;

    # printf "Package not installed:\n%s\n" "${toInstall[@]}";
    sudo pacman --noconfirm -S "${toInstall[@]}" --ask 4;
}

_installPackagesYay() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledYay "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All packages are already installed.";
        return;
    fi;

    # printf "AUR packags not installed:\n%s\n" "${toInstall[@]}";
    $aur_helper --noconfirm -S "${toInstall[@]}";
}

_installPackagesAUR() {
    toInstall=();
    for pkg; do
        if [[ $(_isInstalledYay "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed.";
            continue;
        fi;
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All packages are already installed.";
        return;
    fi;

    # printf "AUR packags not installed:\n%s\n" "${toInstall[@]}";
    $aur_helper --noconfirm -S "${toInstall[@]}";
}

_forcePackagesYay() {
    toInstall=();
    for pkg; do
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All packages are already installed.";
        return;
    fi;

    # printf "AUR packags not installed:\n%s\n" "${toInstall[@]}";
    $aur_helper --noconfirm -S "${toInstall[@]}" --ask 4;
}

_forcePackagesAUR() {
    toInstall=();
    for pkg; do
        toInstall+=("${pkg}");
    done;

    if [[ "${toInstall[@]}" == "" ]] ; then
        # echo "All packages are already installed.";
        return;
    fi;

    # printf "AUR packags not installed:\n%s\n" "${toInstall[@]}";
    $aur_helper --noconfirm -S "${toInstall[@]}" --ask 4;
}

_installPackagesFlatpak() {
     toInstall=();
    for pkg; do
        sudo flatpak install -y flathub "${pkg[@]}";
        if [[ $(_isInstalledFlatpak "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is installed.";
            toInstall+=("${pkg}");
            continue;
        fi;
    done;

    sudo flatpak install -y flathub "${toInstall[@]}";
}

# ------------------------------------------------------
# Protect files or folder from been overwritten by an update
# ------------------------------------------------------
_protect() {
    echo ":: protect $1"
    if [ -d $ml4w_directory/$version/$1 ] ;then
        rm -rf $ml4w_directory/$version/$1
        echo ":: Folder $1 protected"
    elif [ -f $ml4w_directory/$version/$1 ] ;then
        rm $ml4w_directory/$version/$1
        echo ":: File $1 protected"
    else 
        echo "$1 not found"
    fi
}