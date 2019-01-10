#!/bin/sh

# Create md5 files for its subdirectories and files in the given directories.

build="yes"
OPTION="[-build=yes|no]"
USAGE="Usage: $0 dir1 dir2 ... dirN"

[ $# -lt 1 ] && echo "$USAGE" && exit 1

while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  # directory name
  elif [ -d "$1" ]; then

    # get directory name
    dname=${1%/}	# strip off a trailing '/'

    find "$dname" | while read fname; do
    if [ -f "$fname" ]; then
      f=${fname##*/}
      d=${fname%/*}
      echo " '$d' $f"
    fi
      # md5sum "$fname" >> "$md5"
    done

    # [ ! -f "$fullname/$dirname.txt" ] && echo "Warning: No '$fullname/$dirname.txt'"

  # what is it?
  else
    echo ""
    echo "$1: not a directory!"
  fi

  shift

done
