#!/usr/bin/env bash

# --------------------------------------------------------------
# Icons
# --------------------------------------------------------------

TEMP_DIR=$(mktemp -d -t ml4w-icons-XXXXXX)
ICON_DIR="$HOME/.local/share/icons/"
mkdir -p $ICON_DIR
git clone --depth 1 https://github.com/bikass/kora.git $TEMP_DIR
echo ":: kora icon theme cloned into $TEMP_DIR"

# copy icon folders
cp -rf $TEMP_DIR/kora $ICON_DIR
cp -rf $TEMP_DIR/kora-pgrey $ICON_DIR
echo ":: kora icon theme installed in $ICON_DIR"

# clean up
rm -rf $TEMP_DIR