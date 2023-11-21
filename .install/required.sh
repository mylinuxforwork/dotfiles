# ------------------------------------------------------
# Check that rsync is installed
# ------------------------------------------------------

echo "Checking that rsync and gum is installed..."
_installPackagesPacman "rsync";
_installPackagesPacman "gum";