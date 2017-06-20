#!/bin/sh
#Title:			   AddFavoriteShares.sh
#Description:	 This will populate a users "Connect to Server" 
#				       menu with the servers you specify.
#Author:		   Drew Diver
#Date:			   2017-06-20
#==================================================================

# CONSTANTS
sfltool=/usr/bin/sfltool
plist=com.apple.LSSharedFileList.FavoriteServers

# SUPPRESS ERRORS FROM JSS
exec 2>/dev/null

# ADD SHARES TO "FAVORITE SERVERS" LIST UNDER "CONNECT TO SERVER"
$sfltool add-item -n "First Share Name" $plist "smb://my.first.share/public"
$sfltool add-item -n "Second Share Name" $plist "smb://my.second.share/tmp"
