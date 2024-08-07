# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------

echo "Do you want to check for new packages only (faster installation)"
echo "or do you want to reinstall all packages again? (more robust and can help to fix issues)"
echo
if gum confirm "How do you want to proceed?" --affirmative "New packages only" --negative "Force reinstallation" ;then
    force_install=0
elif [ $? -eq 130 ]; then
    echo ":: Installation canceled."
    exit 130
else
    force_install=1
fi
