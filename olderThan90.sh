#!/bin/sh

userCount=0
userArray=$(find /Users ! -name 'Shared' -type d -mtime +90 -maxdepth 1)

for user in "${userArray[@]}"
do
    echo "Deleting user: $user..."
    dscl . -delete $user
    ((userCount += 1))
done

if [ $? -eq 0 ]
then
    echo "$userCount accounts successfully deleted!"
    exit 0
else
    exit 1
fi
