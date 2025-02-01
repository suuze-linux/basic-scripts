#!/bin/bash
#
# Simple bash script to display the public IP address currently in use
# by the invoking machine. 
#
# Relies on:
# - AWS' checkip service at https://checkip.amazonaws.com/, and
# - assumes curl is installed in /usr/bin/.
#

/usr/bin/curl https://checkip.amazonaws.com/
