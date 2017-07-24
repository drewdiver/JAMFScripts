# Harmonic Media Grid Settings

These are some scripts that we use in-house to manage Harmonic Media Grid
settings via JAMF Casper suite.

These are based on the recommended defaults that were given to us by Harmonic.

## gridSettings.sh
The first script gridSettings.sh will first grab the current console user and
the UUID, we then unmount any specified Media Grid
shares, the last setup is to check if System Preferences is running and quit if so. Leaving
System Preferences open caused odd behaviour when trying to push the settings.

For the settings plist, I initially tried generating a plist to push via JAMF, however this would never
take. After ~~some~~ a lot of testing the best solution was to create the plist on the spot
via bash in the appropiate directory.

Once completed, we reload the plist changes with a `killall cfprefsd`

You can verify the changes, by re-opening System Preferences and viewing the
Media Grid section.

## sysctlSettings.sh
This modifies the /etc/sysctl.conf file enabling recommended settings for the
Media Grid

Utilizing ed instead of sed we can retain permissions on the same file when
adding edits. If we detect the pattern "net." we can tell this is already
configured. This could probably be more thourough but in my environment, this
was not an issue.

Otherwise, if sysctl.conf does not exist we create one with the defaults.

## omfsVersion.sh
This can be setup in JAMF as an Extension Attribute to show the OMFS version for
each computer record to track updates, etc.

Remember, Extension Attributes update when the computer runs inventory once
every 24 hours.

## Moving on

Perhaps someone in the same situation will find these useful. I think I've
documented them thoroughly, but if you have any questions or insight, please
reach out! I've heard an official Apple driver which allows for packaging
settings is on the way from Harmonic, but this set of scripts works pretty well
and allows for more flexibility.

As of 2016 I am no longer with the company using these, though I keep in touch
on the status. Weirdly Harmonic never responds about this fix...
