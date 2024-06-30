#!/bin/bash
#   _____      ____      __
#  / _ \ \ /\ / /\ \ /\ / /
# |  __/\ V  V /  \ V  V / 
#  \___| \_/\_/    \_/\_/  
#                          
EWW=`which eww`
if [[ ! `pidof eww` ]]; then
	${EWW} daemon
	sleep 0.5
fi
