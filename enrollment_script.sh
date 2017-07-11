#!/bin/sh
#
# Drew Diver 2017
# NetEnt Enrollment Script
#
# Note: Order matters! Be aware of any additions.
#       FileVault MUST be called last as it will force reboot.
#       DockUtil MUST be installed before you can "setup_dock" etc.
#
# This is a template for how I setup computer enrollment. We utilize Dockutil
# for managing the dock and ProgressScreen.app to show a status as each policy
# executes. If you are not using either, you will need to remove those components.
# You may want to deploy a package with a custom image you can call for this and
# future message prompts via the jamfHelper.

# Setup Success/Error prompt for end of script
JAMF="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
ICON="/Library/Application Support/path/to/custom/icon.png" # PNG File 512x512
TITLE="<Your Company> Enrollment"
SUCCESS_MSG="Enrollment has completed successfully!"
ERROR_MSG="There were issues during enrollment, please see IT."

# Grab FileVault status for later
fv_status=$(fdesetup isactive)

# All of our event triggers to iterate through.
# Tick the "Custom" box in the policy and give it a name.
# Remember: Order matters!
triggerArray=("set_wallpaper"
          "launch_progress"
          "install_flash"
          "install_firefox"
          "install_chrome"
          "install_hipchat"
          "install_skype"
          "install_eset"
          "install_vpn"
          "deploy_sam"
          "install_printers"
          "install_word"
          "install_excel"
          "install_powerpoint"
          "install_onenote"
          "install_outlook"
          "install_onedrive"
          "install_pptemplates"
          "install_selfheal"
          "install_dockutil"
          "setup_dock"
          "add_favoriteservers"
          "set_hostname"
             )

# Suppress output as not to trigger error message at
# end of script execution
exec 2>/dev/null

# Iterate through and run each trigger
for trigger in "${triggerArray[@]}"
do
    jamf policy -event $trigger
    sleep 3
done

# Enable FileVault if it isn't already enabled.
if [[ $fv_status == false ]];
then
    jamf policy -event enable_filevault
else
    # If not using ProgressScreen remove this else and
    # continue on to the success message.
    killall ProgressScreen
fi

# Display Success or Error message based on exit status of enrollment
if [ $? -eq 0 ]
then
  "$JAMF" -windowType "utility" -icon "$ICON" -title "$TITLE" -description "$SUCCESS_MSG" -button1 "Close" -defaultButton 1
  exit 0
else
  "$JAMF" -windowType "utility" -icon "$ICON" -title "$TITLE" -description "$ERROR_MSG" -button1 "Close" -defaultButton 1
  exit 1
fi
