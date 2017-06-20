#!/bin/sh -e
# Copyright 2016 Drew Diver
# An Extension Attribute to display OMFS version in the JSS

OMFS_KEXT=/Library/Extensions/omfs.kext
VERSION=$(defaults read /Library/Extensions/omfs.kext/Contents/Info.plist CFBundleVersion )

# If the kernel extension exists, show the version,
# otherwise tell us it's not installed.
if [ -e $OMFS_KEXT ]; then
  echo "<result>$VERSION</result>"
else
  echo "<result>No OMFS driver installed.</result>"
fi
