#!/bin/sh
#Title:			   enableSSH.sh
#Description:		   Ensures only the JAMF Management and local admin are enabled for SSH
#			   Good to be ran at enrollment and weekly
#Author:		   Drew Diver
#Date:			   2017-06-20
#=======================================================================================

# Access Group File for SSH
ssh_group="com.apple.access_ssh"

# Enable SSH if not already enabled
if [[ $(systemsetup -getremotelogin) == 'Remote Login: Off' ]];
then
    echo "Turning on Remote Login/SSH"
    systemsetup -f -setremotelogin on
fi

# Remove the existing SSH access group
dseditgroup -o delete -t group $ssh_group

# Create a new access group
dseditgroup -o create -q $ssh_group

# Add the JAMF Management account
dseditgroup -o edit -a management_account -t user $ssh_group

# Add the local admin account
dseditgroup -o edit -a admin_account -t user $ssh_group

exit 0
