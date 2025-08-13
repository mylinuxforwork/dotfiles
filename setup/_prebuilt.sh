#!/usr/bin/env bash
# --------------------------------------------------------------
# Prebuilt Packages
# --------------------------------------------------------------

echo "Installing Matugen v2.4.1 into ~/.local/bin"
# https://github.com/InioX/matugen/releases
cp $SCRIPT_DIR/packages/matugen $HOME/.local/bin

echo "Installing Wallust v3.4.0 into ~/.local/bin"
# https://codeberg.org/explosion-mental/wallust/releases
cp $SCRIPT_DIR/packages/wallust $HOME/.local/bin