#!/bin/bash
cat <<"EOF"
  ____ _____ _  __
 / ___|_   _| |/ /
| |  _  | | | ' / 
| |_| | | | | . \ 
 \____| |_| |_|\_\
                  
EOF

# version="dotfiles"

# Remove existing symbolic links
gtk_symlink=0
gtk_overwrite=1
if [ -L ~/.config/gtk-3.0 ]; then
  rm ~/.config/gtk-3.0
  gtk_symlink=1
fi

if [ -L ~/.config/gtk-4.0 ]; then
  rm ~/.config/gtk-4.0
  gtk_symlink=1
fi

if [ -L ~/.gtkrc-2.0 ]; then
  rm ~/.gtkrc-2.0
  gtk_symlink=1
fi

if [ -L ~/.Xresources ]; then
  rm ~/.Xresources
  gtk_symlink=1
fi

if [ "$gtk_symlink" == "1" ] ;then
  echo ":: Existing symbolic links to GTK configurations removed"
fi

if [ -d ~/.config/gtk-3.0 ] ;then
  echo "The script has detected an existing GTK configuration."
  if gum confirm "Do you want to overwrite your configuration?" ;then
    gtk_overwrite=1
  else
    gtk_overwrite=0
  fi
fi

if [ "$gtk_overwrite" == "1" ] ;then
  cp -r ~/dotfiles-versions/$version/gtk/gtk-3.0 ~/.config/
  cp -r ~/dotfiles-versions/$version/gtk/gtk-4.0 ~/.config/
  cp -r ~/dotfiles-versions/$version/gtk/xsettingsd ~/.config/
  cp ~/dotfiles-versions/$version/gtk/.gtkrc-2.0 ~/.config/
  cp ~/dotfiles-versions/$version/gtk/.Xresources ~/.config/
  echo ":: GTK Theme installed"
fi
