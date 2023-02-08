#!/bin/sh
#

echo -e "Enter the git commit message: \c "
read comment
git add -A
git commit -m "$comment"
git push

