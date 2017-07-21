#!/bin/sh

userCount=0
# Pull the current logged in user and omit in search as a fail-safe
currentUser=$(ls -l /dev/console | awk '{ print $3 }')
userArray=$(find /Users ! -name 'Shared' ! -name "$currentUser" -type d -mtime
            +91 -maxdepth 1 -mindepth 1)

for user in "${userArray[@]}"
do
    echo "Deleting user: $user..."
    # Delete the account from the local user database
    dscl . -delete $user
    # Delete the accounts home folder
    rm -rf /Users/$user
    ((userCount += 1))
done

if [ $? -eq 0 ]
then
    echo "$userCount accounts successfully deleted!"
    exit 0
else
    exit 1
fi
