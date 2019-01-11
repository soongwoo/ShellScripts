#!/bin/sh

# Create a file, which has md5sum for all files in the given directory.

OPTION="[-mode=debug]"
USAGE="Usage: $0 dir1 dir2 ... dirN"

[ $# -lt 1 ] && echo "$USAGE" && exit 1

curdir=$(pwd)

while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  # directory name
  elif [ -d "$1" ]; then

    dname=${1%/}	# remove trailing slash char
    md5="$dname".md5

    # check md5sum file
    echo ""
    if [ -z "$(ls -A $dname)" ]; then
      echo "$1: empty directory!"
    elif [ -f "$dname/$dname.md5" ]; then
      echo "$dname: $md5 exists!"
    else
      echo "$dname: Create $md5 ..."

      curdir=$(pwd)
      cd "$dname"
      find * -type f | while read fname; do
        echo " $fname"
        md5sum "$fname" >> "$md5"
      done
      cd "$curdir"

      # [ ! -f "$dname/$dname.txt" ] && echo "Warning: No '$dname/$dname.txt'"
    fi

  # what is it?
  else
    echo -e "\n$1: not a directory!"
  fi

  shift

done
