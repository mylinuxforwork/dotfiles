#!/bin/bash
_getHeader "$name" "$author"
echo "$homepage ($email)"
echo "Version" $(_getVersion)
echo ""
echo $description
