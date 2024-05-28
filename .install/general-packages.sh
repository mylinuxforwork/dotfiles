# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------

echo -e "${GREEN}"
figlet "General Packages Profiles"
echo -e "${NONE}"

install_general_packages() {
  local packages_dir="$HOME/Downloads/dotfiles/.install/packages/general-packages"
  local firefox_installed=false

  echo "Please select what file you want to install packages from: "
  local package_files=($(find "$packages_dir" -maxdepth 1 -type f -name "*.sh"))
  local selected_files=( )
  for file in "${package_files[@]}"; do
    selected_files+=("$(basename "$file")")
  done
  local selected_files=($(gum choose "${selected_files[@]}"))

  for file in "${selected_files[@]}"; do
    echo "Installing $file..."
    source "$packages_dir/$file"
    if [[ $file == *firefox* ]]; then
      firefox_installed=true
    fi
  done

  if $firefox_installed; then
    echo "Firefox was installed. Setting it as the default browser in $HOME/Downloads/dotfiles/.settings/browser.sh..."
    echo "firefox" > "$HOME/Downloads/dotfiles/.settings/browser.sh"
  fi
}

install_general_packages