#!/bin/sh
#

USAGE="$0 extension target-substring [new-substring]"
newstring=""

# check the arguments
[ $# -lt 2 ] && echo "$USAGE" && exit 1
[ $# -eq 3 ] && newstring="$3"

ext="$1"
substring="$2"

for oldname in *"$ext"; do
  newname=`echo ${oldname/"$substring"/"$newstring"}`
  [ "$oldname" != "$newname" ] && mv "$oldname" "$newname"
done

exit 0
