#!/bin/sh
#
# Change the prefix to the new one.
#

USAGE="$0 [-dir=.] [-debug=0] <old prefix> [new prefix]"

# check the arguments
[ $# -lt 1 ] && echo "$USAGE" && exit 1
oldprefix=""
newprefix=""
dir="."
debug=0

while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  # assign oldprefix
  elif [ -z "$oldprefix" ]; then
    oldprefix="$1"

  # assign newprefix
  elif [ -z "$newprefix" ]; then
    newprefix="$1"

  else
    echo "'$1': too many prefix: ignored"

  fi

  shift

done

# if no no prefix is provided, 
[ -z "$oldprefix" ] && echo "$USAGE" && exit 1

# save current working diretory
curdir=$(pwd)
len=${#oldprefix}
[ $debug -gt 0 ] && echo "dir='$dir' oldprefix='$1' newprefix='$newprefix' length=$len curdir='$curdir'"

# rename them ...
cd "$dir"
for oldname in "$oldprefix"*; do
  # newname=${oldname#$oldprefix}
  newname="$newprefix"${oldname:$len}
  [ -e "$oldname" ] && echo "Rename to '$newname'" && mv "$oldname" "$newname"
done
cd "$curdir"

exit 0
