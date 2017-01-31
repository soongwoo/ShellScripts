#!/bin/bash
#
# Compare files and directories in two drives.
#

OPTION="[-first=1] [-last=0]"
USAGE="Usage: $0 $OPTION target-drive"

first=1
last=0
target="NONE"

# compare files and directories
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  elif [ "$target" == "NONE" ]; then
     target=$1
  else
    echo "Too many target drive specified"
  fi

  shift

done

# check variables
[ "$target" == "NONE" ] && echo "No target drive specified" && exit 1


# main function
counter=0
for i in *; do

  # skip $RECYCLE.BIN
  name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System /}; [ "$i" != "$name" ] && continue;

  # check whether it is in the given range
  (( counter++ ))
  if [ $counter -lt $first ]; then continue
  elif [ $counter -gt $last ]; then break
  else

    # compare files and directories
    echo "$i";
    if [ -d "$i" ]; then
      diff -r "$i" /cygdrive/"$target"/"$i";
    else
      diff "$i" /cygdrive/"$target"/"$i";
    fi

  fi

done

exit 0
