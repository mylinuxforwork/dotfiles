#!/bin/sh
rsync -av --exclude-from=excludes.txt ../ ~/dotfiles/
