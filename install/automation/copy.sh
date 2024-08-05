echo -e "${GREEN}"
figlet "Copy dotfiles"
echo -e "${NONE}"
if [ ! -d ~/$dot_folder ]; then
    mkdir -p ~/$dot_folder
    echo ":: AUTOMATION: ~/$dot_folder folder created."
fi   
rsync -avhp -I ~/dotfiles-versions/$version/ ~/$dot_folder/
if [[ $(_isFolderEmpty ~/$dot_folder/) == 0 ]] ;then
    echo "AN ERROR HAS OCCURED. Copy prepared dofiles from ~/dotfiles-versions/$version/ to ~/$dot_folder/ failed" 
    echo "Please check that rsync is installad on your system."
    echo "Execution of rsync -a -I ~/dotfiles-versions/$version/ ~/$dot_folder/ is required."
    exit
fi
echo ":: AUTOMATION: Prepared dotfiles copied to ~/$dot_folder"
