#!/bin/bash
_getHeader "$name" "$author"
echo "$homepage ($email)"
echo "Settings Version" $(_getVersion)
echo ""
echo $description
