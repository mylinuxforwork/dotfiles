#!/bin/sh

fc-list \
    | grep -ioE ": [^:]*$1[^:]+:" \
    | sed -E 's/(^: |:)//g' \
    | tr , \\n \
    | sort \
    | uniq
