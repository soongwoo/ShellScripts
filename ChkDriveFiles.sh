#!/bin/bash
#
# Compare files and directories in two drives.
#

OPTION="[-debug=0] [tag=A]"
USAGE="Usage: $0 $OPTION drive-letter"

tag=A
drv="NONE"
debug=0

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

  # compare files and directories
  if [ -e /cygdrive/"$drv"/"$i" ]; then

    echo "$i";

    # if [ -d /cygdrive/"$drv"/"$i" ]; then arg="-r"; else arg=""; fi
    # result=$(diff "$arg"  "$i" /cygdrive/"$drv"/"$i");

    result=$(diff -r "$i" /cygdrive/"$drv"/"$i");

    # rename the source when the target is same as the source
    if [ "$?" -eq 0 ]; then (( counter++ )); mv "$i" "$tag"."$i"; fi

  fi

done

[ "$debug" -ne 0 ] && echo "";
[ "$debug" -ne 0 ] && echo "$counter source(s) are same!"
[ "$debug" -ne 0 ] && echo ""

exit 0
