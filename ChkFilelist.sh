#!/bin/sh

# Check the existence of files which are listed in the md5sum checksum file in the given directory.

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

    # take off '/', if it is a last character.
    fullname="$1"
    lastch=$(echo -n "$fullname" | tail -c -1)
    [ "$lastch" == "/" ] && fullname=${fullname/%\//}

    # get directory name
    dirname=${fullname##.*\/}
    md5="$dirname".md5

    echo ""
    echo "$1: Check its integrity of '$1' ..."

    cd "$1"
    find * -type f | while read fname; do
      if [ "$md5" != "$fname" ]; then
        result=$(grep "$fname" "$md5")
        if [ "$?" -ne 0 ]; then
          echo "'$fname': No"
        else
          echo "'$fname': Yes"
        fi
      fi
    done
    cd "$curdir"

  # what is it?
  else
    echo ""
    echo "$1: not a directory!"
  fi

  shift

done
