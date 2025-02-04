#!/bin/bash
makepkg --printsrcinfo >.SRCINFO
echo ":: .SRCINFO created"
commit_msg=$(gum input --placeholder "Enter your commit-message")
if gum confirm "Do you want to commit?"; then
    git add -f PKGBUILD .SRCINFO
    git commit -m "$commit_msg"
    echo ":: Commit created with $commit_msg"
    if gum confirm "Do you want to push?"; then
        git push
    fi
fi
