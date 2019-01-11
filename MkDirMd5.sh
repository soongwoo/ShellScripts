#!/bin/sh

# Create md5 files for its subdirectories and files in the given directories.

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

    # get directory name
    dname=${1%/}	# strip off a trailing '/'

    # check md5sum file
    echo ""
    if [ -z "$(ls -A $dname)" ]; then
      echo "$1: empty directory!"
    elif [ -f "$dname/$dname.md5" ]; then
      echo "$dname: $md5 exists!"
    else
      echo "$dname: Create $md5 ..."

      find "$dname" | while read fname; do
        if [ -f "$fname" ]; then
          f=${fname##*/}	# filename
          d=${fname%/*}	# full directory name
          m=${d##*/}	# directory
          [ "$mode" == "debug" ] && echo " '$d' '$m' $f"
          dd="$d""/"	# full directory name with trailing slash

          md5="$(md5sum "$fname")"	# get md5sum of $fname
          md5=${md5//$dd/}		# format the filename in md5sum string
          [ "$mode" == "debug" ] && echo "$md5" 
	  echo "$md5" >> "$d"/"$m".md5	# store the md5sum string in the right place

          # cd "$d"
          # md5sum "$f" >> "$m".md5
          # cd "$curdir"

        fi
      done

    fi

  # what is it?
  else
    echo ""
    echo "$1: not a directory!"
  fi

  shift

done
