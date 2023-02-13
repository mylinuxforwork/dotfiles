#!/bin/sh

read -p "Enter the git commit message: " comment
git add -A
git commit -m "$comment"
git push

