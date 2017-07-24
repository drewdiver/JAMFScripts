# Automatically Map Network Shares at Login

This consists of a LaunchAgent and shell script to be placed in
/Library/LaunchAgents and /Library/Scripts respectively.

## Create a DMG for Deployment with JAMF
1. Drag com.management.mapnetworkshares.plist to /Library/LaunchAgents
2. Drag mapNetworkShares.sh to /Library/Scripts
3. Open Composer.app
4. Click "New" > Select > "User Environment" > "Dashboard"
5. Delete the Users folder that is auto-populated in the main window
6. From /Library/LaunchAgents, drag the plist into the main composer window
7. Do the same for the mapNetworkShares.sh
8. Select com.management.mapnetworkshares.plist and set the permissions to mode
   644 as follows:
   Owner: root (0) with Read and Write
   Group: wheel (0) Read-only
   Everyone: Read-only
9. Select the mapNetworkShares.sh and set the permissions to mode 744 as
   follows:
   Owner: root (0) with Read Write and Execute checked
   Group: Wheel (0) with Read-only
   Everyone: Read-only
10. Click "Build as DMG" from the top menu

We can now import this DMG to Casper Admin, since this is a DMG, we can allow
for it to be uninstalled via Casper Remote.

## Create a policy to deploy the LaunchAgent and Script
1. Login to the JSS and start a new policy creation
2. Give this a name (ex: "Map Network Shares at Login")
3. Click "Packages" and add our newly added DMG
4. Select "Files and Processes"
5. The very last option "Execute Command" add the following:
   `launchctil /Library/LaunchAgents/com.management.mapnetworkshares.plist`

## Scopt the policy as necessary
here will be a 20 second delay which can be adjusted in the mapNetworkShares.sh
script. I've noticed it can take a few at startup before the machine connects to
Wi-Fi.
