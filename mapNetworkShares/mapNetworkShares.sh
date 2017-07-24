#!/bin/sh
#Title:               MapNetworkShares.sh
#Description:         Map specified shares at login
#Author:              Drew Diver
#Date:                2017-07-24
#===================================================

# Shares array, one per line like so:
shares=(
    "your-smb-share/folder"
    "your-other-smb/folder"
)

# Suppress errors from cluttering the JSS logs.
exec 2>/dev/null

# Add a delay of 20 seconds to allow the Mac to connect
# via Wi-Fi or pull via Ethernet.
sleep 20

# Mount the temp and public drives (if they aren't already mounted).
for share in "${shares[@]}"
do
             if ! mount | grep -qs $share; then
	         osascript -e "mount volume \"smb://$share\""
             fi
done
