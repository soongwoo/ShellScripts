#!/bin/sh

# Remove the given prefix from the directory/filename name 

OPTION="[-prefix=Movie]"
USAGE="Usage: $0 $OPTION file1 file2 ... fileN"
prefix="Movie"

[ $# -le 1 ] && echo "$USAGE" && exit 1

while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  # check whether it exists
  elif [ ! -e "$1" ]; then
    echo "$1: no file or directory"

  # process arguments
  else
    oldname="$1"
    newname=${oldname/"$prefix""."/}
    [ "$oldname" != "$newname" ] && echo "rename to '$newname'" && mv "$oldname" "$newname";
  fi

  shift

done
