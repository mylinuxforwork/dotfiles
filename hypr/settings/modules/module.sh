#!/bin/bash
_getHeader "$name" "$author"
echo "$homepage ($email)"
echo "ML4W dotfiles Version 2.7"
echo "Settings Version" $(_getVersion)
echo ""
echo $description
