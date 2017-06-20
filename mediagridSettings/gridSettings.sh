#!/bin/bash
# Script by Drew Diver, 2015
# Sets default readAhead and network interfaces for currently logged in user(s).
# for Harmonic MediaGrid

#############
# VARIABLES #
#############

# CHANGE THIS TO REFLECT THE NAME
# OF YOUR OWN SHARE.
SHARE=""

activeUser=(ls -l /dev/console | awk '{ print $3 }')
UUID=$(ioreg -rdc1 -c IOPlatformExpertDevice | grep IOPlatformUUID | awk '{ print $4 }' | tr -d \")

################
# SANITY CHECK #
################

# Unmount the OMFS file share
diskutil unmountDisk /Volumes/$SHARE

# Kill System Preferences if currently open
if ps ax | grep '[S]ystem Preferences'
then
killall System\ Preferences
fi

############
# THE CODE #
############

cat > /Users/$activeUser/Library/Preferences/ByHost/com.harmonicinc.MediaGrid.Preferences.$UUID.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple/DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>cache</key>
	<true/>
	<key>caseinsensitive</key>
	<false/>
	<key>interfaceList</key>
	<string></string>
	<key>noopendelete</key>
	<false/>
	<key>priority</key>
	<true/>
	<key>readAhead</key>
	<integer>12</integer>
	<key>singlewriter</key>
	<false/>
	<key>useInterfaces</key>
	<integer>1</integer>
</dict>
</plist>
EOF

# Reload the plist changes
killall cfprefsd

if [ $? -eq 0 ]; then
	echo "Successfully created plist."
else
	echo "Could not modify plist" >&2
fi
