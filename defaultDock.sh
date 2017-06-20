#!/bin/sh
#Title:			   defaultDock.sh
#Description:		   Generates a default dock utilizing dockutil
#
#Author:		   Drew Diver
#Date:			   2017-06-20
#==================================================================

# Check if 'dockutil' is installed.
command -v dockutil >/dev/null 2>&1 || { echo >&2 "dockutil not found, aborting"; exit 1; }

# Path to dockutil so I don't have to keep typing it over and over...
DOCKUTIL=/usr/local/bin/dockutil

# Get the current user
currentUser=$(ls -l /dev/console | awk '{ print $3 }')

# Generate the path to the current users dock plist.
# If you run without specifying, JAMF runs as root and will therefore
# attempt to alter its own dock.
PLIST=/Users/$currentUser/Library/Preferences/com.apple.dock.plist

# List of apps to append to dock
applicationsArray=("Safari.app"
                   "FireFox.app"
                   "Google Chrome.app"
                   "HipChat.app"
                   "Self Service.app"
                  )

# First clear the dock, applying '--no-restart' to save all the changes
# until the very end
/usr/local/bin/dockutil --remove all --no-restart $PLIST

# Iterate the array and add each in order
for app in "${applicationsArray[@]}"
do
  $DOCKUTIL --add /Applications/$app --no-restart $PLIST
done

# Add Downloads folder shortcut to Dock
$DOCKUTIL --add "/Users/$currentUser/Downloads" --view grid --display folder --no-restart $PLIST

# Force reload plists
killall cfprefsd

# Refresh the dock
killall Dock
