#!/bin/bash
#
# Compare files and directories in two drives.
#

#OPTION="[-first=1] [-last=0]"
OPTION=""
USAGE="Usage: $0 $OPTION drive-letter"

#first=1
#last=0
drv="NONE"

# compare files and directories
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  elif [ "$drv" == "NONE" ]; then
     drv=$1
  else
    echo "Too many drv drive specified"
  fi

  shift

done

# check variables
[ "$drv" == "NONE" ] && echo "No drv drive specified" && exit 1
# should add a statement which checks whether the given drive is valid.

# main function
counter=0
for i in *; do

  # skip $RECYCLE.BIN
  name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System /}; [ "$i" != "$name" ] && continue;

  # check whether it is in the given range
  (( counter++ ))
#  if [ $counter -lt $first ]; then continue
#  elif [ $counter -gt $last ]; then break
#  else

    # compare files and directories
    echo "$i";
    if [ -d /cygdrive/"$drv"/"$i" ]; then
      diff -r "$i" /cygdrive/"$drv"/"$i";
    elif [ -e /cygdrive/"$drv"/"$i" ]; then
      diff "$i" /cygdrive/"$drv"/"$i";
    fi

#  fi

done

exit 0
