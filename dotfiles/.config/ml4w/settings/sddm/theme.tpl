[General]

# Set to your screen resolution for better results
width=1680
height=1050

backgroundColour="black"

wallpaper="backgrounds/CURRENTWALLPAPER"

# Whether to scale the image to fit on the screen, might leave some blank spaces
# will scale and crop the wallpaper if left false
fitWallpaper=false

# Main font
fontFamily="Noto Sans"

# Set to a patched NerdFont if some icons don't display properly
# or leave empty to use the main font family
iconFont=""

# Set this if fonts are the wrong size for your resolution
fontSize=14

# Whether to show icons inside menus
iconsInMenus=true


# [Colour_Palette]

# The main colour for text and icons
primaryColour="white"

# The background colour of popup panels
popupsBackgroundColour="white"

# Used for the text and icons inside popup panels
popupsForegroundColour="black"

# Colour used for selected and focused items
accentColour="#a7d9ea"


# [Greeting_Screen]

# Set true to be taken directly to the login screen
skipToLogin=false

# Supports Markdown formatting, leave empty to not display any text
greeting="Welcome back!"

# Adjusts the font size for the greeting message, clock and date
fontSizeMultiplier=2

# For help with date and time formatting see https://doc.qt.io/qt-5/qml-qtqml-date.html#format-strings
clockFormat="HH:mm"
dateFormat="dddd, dd MMMM"

# Set this in case the date isn't in your system locale or you wish to use a different one
locale=""

# Styles the clock font
# Set to 'outline' for alternate style
clockStyle=fill

# Anchor the clock to a side or corner of the screen, horizontal position is susceptible to layout mirroring
# Syntax: vertical | horizontal
# possible vertical values:  top - center - bottom
#           and horizontal: left - center - right
dateTimePosition="bottom right"

# Defines how far away the date and time are from the edges of the screen
dateTimePadding=55

# Defines the behaviour of the sliding transition from greeting to login form
# Set to +/- x or y
transitionDirection="x"

# [Login_Screen]

# The maximum radius allowed is 16 per loop
blurRadius=10
blurRecursiveLoops=5

# Used to dim the background
darkenWallpaper=0.3

# Purely cosmetic, has no effect on login credentials
capitaliseUsername=false

# 'mask' - hides your password by replacing the characters with something else
# 'off'  - also hides the length of your password by disabling echoing
passwordEchoStyle=mask

allowEmptyPassword=false

# Set false to hide the selected session's name next to the menu icon
displaySession=true


# [Translations]
# SDDM may not have translations for every element, or you might want to change some text to something else
# setting these will override the text constants

virtualKeyboard=""
poweroff=""
reboot=""
suspend=""
hibernate=""
password=""
username=""
loginFailed=""


# [Accessibility]

# Set false to set all transition durations to 0
enableAnimations=true

# 'auto'  - activates mirroring based on the system locale
# 'false' - never mirror layout
# 'true'  - always mirrors
mirrorLayout=auto

# Whether the on-screen keyboard should be activated by default
# It can always be de/activated through the  accessibility panel
virtualKeyboardStartActive=false

# Normally the on-screen keyboard only shows up when text fields are focused
# Set this true to have the keyboard always be visible once activated
# This will render the hide button on the keyboard non-functional
forceKeyboardVisible=false
