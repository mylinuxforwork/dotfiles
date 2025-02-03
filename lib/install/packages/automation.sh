# ------------------------------------------------------
# Check for automation.sh
# ------------------------------------------------------

if [ -f $ml4w_directory/automation.sh ]; then
    _writeLogTerminal 0 "AUTOMATION: automation.sh found. Automatic installation/update started"
    source $ml4w_directory/automation.sh
    echo
fi