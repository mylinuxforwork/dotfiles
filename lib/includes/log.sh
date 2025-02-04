# -----------------------------------------------------
# Manage installation log file
# -----------------------------------------------------

# Define log file extension
_getLogFile() {
    log_filename="-log.txt"
    echo "$log_folder/$log_date$log_filename"
}

# Get current date and time
_logDateTime() {
    echo $(date '+%Y%m%d%H%M%S')
}

# writeCancel
_writeCancel() {
    _writeLogTerminal 0 "PROCESS CANCELED"
}

# writeSkipped
_writeSkipped() {
    _writeLogTerminal 0 "PROCESS SKIPPED"
}

# Get categories for log entry
_getLogCategory() {
    case $1 in
        0)
            echo "MESSAGE"
            ;;
        1)
            echo "SUCCESS"
            ;;
        2)
            echo "ERROR"
            ;;
        *)
            echo "UNKNOWN"
            ;;
    esac
}

_writeLog() {
    text=$2
    echo "$(_logDateTime) $(_getLogCategory $1) $text" >>$(_getLogFile)
}

_writeLogTerminal() {
    text=$2
    echo "$(_logDateTime) $(_getLogCategory $1) $text" >>$(_getLogFile)
    if [ $1 = "1" ]; then
        echo ":: $(_getLogCategory 1) - $text"
    elif [ $1 = "2" ]; then
        echo ":: $(_getLogCategory 2) - $text"
    else
        echo ":: $text"
    fi
}

_writeLogHeader() {
    echo >>$(_getLogFile)
    echo "# ------------------------------------------------------" >>$(_getLogFile)
    echo "# $1" >>$(_getLogFile)
    echo "# ------------------------------------------------------" >>$(_getLogFile)
    echo >>$(_getLogFile)
}

_writeMessage() {
    echo ":: $1"
}

# Get Date for Log
log_date=$(_logDateTime)

# Debug
# rm -rf $log_folder

# Create ml4w log directory
if [ ! -d $log_folder ]; then
    mkdir -p $log_folder
fi

# Create logfile for installation
touch $(_getLogFile)
