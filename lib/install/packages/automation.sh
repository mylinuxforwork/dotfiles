# ------------------------------------------------------
# Check for automation.sh
# ------------------------------------------------------

if [ -f $ml4w_directory/automation.sh ] ;then
    echo ":: AUTOMATION: automation.sh found"
    source $ml4w_directory/automation.sh
    echo
fi