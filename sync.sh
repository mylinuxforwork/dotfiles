#!/bin/bash
# FOR DEVELOPMENT ONLY
rsync -avhp --exclude={'monitor.conf','keyboard.conf','.gitignore','.git'} -I share/dotfiles/ ~/.mydotfiles/com.ml4w.dotfiles/
