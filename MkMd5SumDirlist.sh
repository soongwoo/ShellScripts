#!/bin/sh

# Create a file, which has md5sum for all files in the given directory.

build="yes"
OPTION="[-build=yes|no]"
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

    # take off '/', if it is a last character.
    fullname="$1"
    lastch=$(echo -n "$fullname" | tail -c -1)
    [ "$lastch" == "/" ] && fullname=${fullname/%\//}

    # get directory name
    dirname=${fullname##.*\/}
    md5="$dirname".md5

    # check md5sum file
    echo ""
    if [ "$build" == "no" ]; then
      if [ ! -f "$fullname/$dirname.md5" ]; then
        echo "$fullname: NO $md5"
      else
        echo "$fullname: $md5 exists!"
      fi
    elif [ -f "$fullname/$dirname.md5" ]; then
      echo "$fullname: $md5 exists!"
    else # if [ ! -f "$fullname/$dirname.md5" ]; then
      echo "$fullname: Create $md5 ..."

      curdir=$(pwd)
      cd "$fullname"
      for fname in *[tivs4f]; do
        echo " $fname"
        md5sum "$fname" >> "$md5"
      done
      cd "$curdir"
    fi

    [ ! -f "$fullname/$dirname.txt" ] && echo "Warning: No '$fullname/$dirname.txt'"

  # what is it?
  else
    echo ""
    echo "$1: not a directory!"
  fi

  shift

done
