#!/bin/sh
#Title:			   enableSSH.sh
#Description:		   Ensures only the JAMF Management and local admin are enabled for SSH
#			   Good to be ran at enrollment and weekly
#Author:		   Drew Diver
#Date:			   2017-06-20
#=======================================================================================

# Set the following to your environment
ssh_admin=YOUR_LOCAL_ADMIN
ssh_mgmt=YOUR_JAMF_MGMT_ACCOUNT

#============= SHOULDN'T NEED TO EDIT BELOW THIS LINE ==================================

# Access Group File for SSH
ssh_group="com.apple.access_ssh"

# Get Remote Login Status
remote_login_status=$(systemsetup -getremotelogin)

# Who is enabled for SSH access?
ssh_members=$(dscl . -read /Groups/com.apple.access_ssh GroupMembership
                    | sed 's/GroupMembership: //')

# Enable SSH if not already enabled
if [[ $remote_login_status == 'Remote Login: Off' ]];
then
    echo "Turning on Remote Login/SSH"
    systemsetup -f -setremotelogin on
fi

# (Silently) check if the members has either admin or mgmt accounts...
echo $ssh_members | grep -E --quiet "($ssh_admin|$ssh_mgmt)"

# If the exit status is not 0, rebuild SSH permissions.
# Perhaps there is a cleaner way to handle this? I was attempting
# to figure out an "OR" grep but couldn't find a clean solution.
if [[ $? != 0 ]]
then
    # Remove the existing SSH access group
    dseditgroup -o delete -t group $ssh_group

    # Create a new access group
    dseditgroup -o create -q $ssh_group

    # Add the JAMF Management account
    dseditgroup -o edit -a $ssh_mgmt -t user $ssh_group

    # Add the local admin account
    dseditgroup -o edit -a $ssh_admin -t user $ssh_group
fi
    
# Error check!
if [ $? -eq 0 ]
then
    echo "Successfully enabled $ssh_admin and $ssh_mgmt for SSH access!"
else
    echo "An error occured enabling SSH..."
    exit 1
fi
