#!/bin/sh

printerQueueName="Printer Queue Name"
printerDriver='Path/to/your/printer/driver'
# Example: '/Library/Printers/PPDs/Contents/Resources/Xerox WorkCentre 7835.gz'
printerURL="smb://your.printer"
printerDescription="Your Printer Name"

# MAIN

# If the printer driver is found, install, else, fail.
if [ -f "${printerDriver}" ]
then
    lpadmin -p "$printerQueueName" \
            -v "$printerURL" \
            -D "$printerDescription" \
            -L "$printerLocation" \
            -P "$printerDriver" \
            -E -o printer-is-shared="False"
    echo "Success!"

    exit 0
else
    echo "ERROR: Driver not found, aborting!"
    exit $?
fi
