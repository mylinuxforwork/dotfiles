# CURRENTLY WORK IN PROGRESS TO CREATE A SDDM THEME

# Install sugar dark as a base
yay -S sddm-sugar-dark

# In the [Theme] section simply add the themes name: Current=sugar-dark
# Copy from /usr/lib/sddm/sddm.conf.d/default.conf
/etc/sddm.conf.d/sddm.conf

# Test the theme
sddm-greeter --test-mode --theme /usr/share/sddm/themes/sugar-dark