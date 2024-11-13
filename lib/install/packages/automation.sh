# ------------------------------------------------------
# Check for automation.sh
# ------------------------------------------------------

if [ -f $ml4w_directory/automation.sh ] ;then
    _writeLog 1 "AUTOMATION: automation.sh found"
    source $ml4w_directory/automation.sh
    echo
fi