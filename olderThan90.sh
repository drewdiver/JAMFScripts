#!/bin/sh

userCount=0
userArray=$(find /Users ! -name 'Shared' -type d -mtime +90 -maxdepth 1)

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
