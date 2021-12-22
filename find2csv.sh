#!/bin/bash
#
# Bash script to recursively find all content under a directory, and output
# contents plus details of contents sizes and modification time stamps to stdout
# in csv (comma delimited) format. Interactively prompts for input. 
#
# Author: suuze_linux
# 
# Usage: ./find2csv.sh
#
# Input from stdin. Script interactively prompts for:
#	- absolute path of top-level folder to start find search from, 
#	- whether to examine hidden files and directories. 
#
# Outputs the following to stdout:
#	- a single header line "File or Folder,Size (bytes),Date Modified"
#	- one comma-delimited line per inode discovered to stdout
#
# Assumptions:
#	1. Bash is available at /bin/bash
#	2. Otherwise, users default path is sufficient. This way we can run 
#	   this script on any standard Unix/Linux machine.
#	3. $HOME environment variable is set to something. We do check for a
#	   valid, navigatable folder.
#
# Exit codes:
#	0 - We got through without picking up any errors. This doesn't mean we
#	    are error-free, just that we aren't aware of any. 
#	1 - $INDIR is not a valid or readable directory
#	2 - $INDIR is valid but cannot parse its contents error-free
#	3 - invalid $CHKHIDDEN response
#
# Things to improve:
#	- $INDIR is tested for being an empty string. It is not tested for 
# 	  being a whole lot of space, but subsequent tests should cover for it. 
#	- A help option.
#	- The ability to choose the field delimiter.
#	- The ability to specify an output file.
#	- The ability to choose what 'ls' options to display.
#
# Modification history
# 2021 Sep 16	suuze_linux	Script created
#

read -p "Enter folder to evaluate (hit enter key to use your home folder): " INDIR
read -p "Do you wish to look for hidden files and folders (y/n)? " CHKHIDDEN

### Check inputs are valid ###

if [[ -z ${INDIR} ]]
then
    echo "Empty string entered, defaulting to home folder ${HOME}..."
    INDIR=${HOME}
fi

if [ -d "${INDIR}" ]
then
    find "${INDIR}" > /dev/null
    if [ "$?" -eq 0 ]
    then
	echo "Validated folder, proceeding..."
    else
	echo "Cannot parse folder \"${INDIR}\" "
	echo "This could be because you do not have permissions to some content in this folder"
	echo "Exiting..."
	exit 2
    fi
else
    echo "Unable to use \"${INDIR}\" "
    echo "Either it isn't a folder or you don't have permissions to it"
    echo "Exiting..."
    exit 1
fi

if [ -z ${CHKHIDDEN} ]
then
    echo "Assuming you don't want to evaluate hidden files and folders..."
    CHKHIDDEN="n"
elif [ "${CHKHIDDEN}" = 'y' -o "${CHKHIDDEN}" = 'Y' ]
then
    echo "Hidden files and folders will be evaluated..."
elif [ "${CHKHIDDEN}" = 'n' -o "${CHKHIDDEN}" = 'N' ]
then
    echo "Hidden files and folders will NOT be evaluated..."
else
    echo "You haven't correctly specified whether to evaluate hidden content"
    echo "Exiting..."
    exit 3
fi

### Do work ###

# Print header
echo "File or Folder,Size (bytes),Date Modified"

# Print other content
if [ "${CHKHIDDEN}" = 'y' -o "${CHKHIDDEN}" = 'Y' ]
then	# evaluate all content, including hidden ones
    find "${INDIR}" | while read INODE
    do
	echo -n "\"${INODE}\","
	ls -dgpQA --time-style=+"%d %b %Y"  "${INODE}" | awk '{print $4","$5" "$6" "$7}'
    done
elif [ "${CHKHIDDEN}" = 'n' -o "${CHKHIDDEN}" = 'N' ]
then	# exclude hidden files and folders
    find "${INDIR}" -not -path '*/\.*' | while read INODE
    do
	echo -n "\"${INODE}\","
	ls -dgpQ --time-style=+"%d %b %Y"  "${INODE}" | awk '{print $4","$5" "$6" "$7}'
    done
fi


