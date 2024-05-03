#!/bin/bash
EWW=`which eww`
if [[ ! `pidof eww` ]]; then
	${EWW} daemon
	sleep 0.5
fi
