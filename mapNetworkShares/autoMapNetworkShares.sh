#!/bin/sh
#Title:			   autoMapNetworkShares.sh
#Description:		   Will prompt to auto-connect to specified shares at user login
#Author:		   Drew Diver
#Date:			   2017-06-20
#========================================================================================

# The volumes we want to mount 
FIRST="/Volumes/first_share"
SECOND="/Volumes/second_share"

# Path to the jamfHelper
JAMF="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Path to PNG file for use in prompt
LOGO="/A/folder/accessible/by/all/users/logo.png"

# Title of the prompt
TITLE="My Company: Connect to Network Shares"

# Message in the prompt
MSG="Please login to the next two prompts with your OFFICE username and password to create shortcuts to our network shares. Note: You may want to \"Remember this password in my keychain\" so you do not have to keep re-entering each login."

# Suppress errors from cluttering the JSS logs.
exec 2>/dev/null

# Add a delay of 10 seconds to allow the Mac to connect
# via Wi-Fi or pull via Ethernet.
sleep 10

# Alert about upcoming prompt for user/pass
"$JAMF" -windowType "utility" -icon "$LOGO" -title "$TITLE" -description "$MSG" -button1 "Next" -defaultButton 1

# Mount the temp and public drives (if they aren't already mounted).
if ! mount | grep -qs $FIRST; then
	osascript -e "mount volume \"smb://my.first.share/first\""
fi

if ! mount | grep -qs $SECOND; then
	osascript -e "mount volume \"smb://my.second.share/second\""
fi
