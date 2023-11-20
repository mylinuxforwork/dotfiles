#!/bin/bash
rsync -a --exclude-from=excludes.txt ../ ~/dotfiles/
