#!/bin/bash
#
# Update files list in the given drives.
#

OPTION="[-debug=0]"
USAGE="Usage: $0 $OPTION"

debug=0

# compare files and directories
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value
  fi

  shift

done

homedir="/cygdrive/c/cygwin64/home/Home"	# archive home directory
drives=(e f k m q z)	# drives
curdir=$(pwd);		# current position

for drv in ${drives[@]}; do

  if [ ! -f /cygdrive/"$drv" ]; then
    echo -n "Create a file list in drive '$drv' ";
  
    cd "$drv":;	# change to drive $drv
    result=$(ls -l * > "$homedir"/files.drive."$drv".txt 2>&1);
    echo;

  else
    echo "'drive $drv' does not exist!";
  fi

done

cd "$curdir";

exit 0
