#!/bin/bash

# DREW DIVER 2016

#############
# VARIABLES #
#############
PATTERN="net."
CONFIG=/etc/sysctl.conf

#############
# FUNCTIONS #
#############
writeConfig ()
{
ed -s /etc/sysctl.conf << 'EOF'
$a
net.inet.tcp.delayed_ack=0
net.link.generic.system.sndq_maxlen=512
net.classq.sfb.allocation=100
.
w
EOF
}

########
# MAIN #
########
if [ -e "$CONFIG" ]; then
	if grep -iq $PATTERN $CONFIG; then
		echo "sysctl.conf is configured properly, exiting!"
		exit 0
	else
		echo "File exists but misconfigured, writing config..."
		writeConfig 2> /dev/null
	fi
else
	echo "Creating /etc/sysctl.conf..."
	touch $CONFIG 2> /dev/null
	echo "Writing config..."
	writeConfig 2> /dev/null
fi

if [ $? -eq 0 ]; then
	echo "Successfuly created file."
else
	echo "Could not create file." >&2
fi
