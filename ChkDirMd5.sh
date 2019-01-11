#!/bin/sh

# Check md5 files for its subdirectories and files in the given directories.

debug=0
OPTION="[-debug=1]"
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

    curdir=$(pwd)
    find "$dname" | while read fname; do
      if [ -f "$fname" ]; then
        f=${fname##*/}	# filename
        d=${fname%/*}	# full directory name
        m=${d##*/}	# directory
        [ "$debug" -ne 0 ] && echo " '$d' '$m' $f"

	cd "$d"
        md5sum "$f" >> "$m".md5
	cd "$curdir"

      fi
    done

    # [ ! -f "$fullname/$dirname.txt" ] && echo "Warning: No '$fullname/$dirname.txt'"

  # what is it?
  else
    echo ""
    echo "$1: not a directory!"
  fi

  shift

done
