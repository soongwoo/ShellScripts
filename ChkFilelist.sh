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
    # fullname="$1"
    # lastch=$(echo -n "$fullname" | tail -c -1)
    # [ "$lastch" == "/" ] && fullname=${fullname/%\//}

    # get directory name
    # dirname=${fullname##.*\/}
    dname=${1%/}
    md5="$dname".md5

    echo ""
    echo "$dname: checking the file existence in '$md5'"

    cd "$dname"

    # check txt file existence
    [ ! -e "$dname".txt ] && echo " '$dname.txt': NO"

    # if no $md5, then create it
    [ ! -e "$md5" ] && touch "$md5"

    # check all files in the directory
    find * -type f | while read fname; do
      if [ "$md5" != "$fname" ]; then
        result=$(fgrep "$fname" "$md5")
        if [ "$?" -ne 0 ]; then
          echo " '$fname': Added"
          md5sum "$fname" >> "$md5"
        else
          echo " '$fname': YES"
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
