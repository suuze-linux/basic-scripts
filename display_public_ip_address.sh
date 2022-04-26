#!/bin/bash
#
# Simple bash script to display the public IP address currently in use
# by the invoking machine. 
#
# Uses AWS' checkip service and assumes curl is installed in /usr/bin/.
#

/usr/bin/curl https://checkip.amazonaws.com/
