#!/bin/bash
#
# Rename SMI upon its corresponding video file.
#
# Revisions:
#

OPTION="[-debug=0] [-key=4]"
USAGE="Usage: $0 $OPTION video-file-extention"

# initialize variables with default value
debug=0
key=4

# do main task
[ $# -eq 0 ] && echo "$USAGE" && exit 1

count=0
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value
    shift
    continue
  fi

  ext="$1"

  find *."$ext" -type f | while read fullname; do

    filename=$(basename "$fullname")   # extract filename
    filename=${filename%.*}            # remove extension

    [ "$debug" -eq 1 ] && echo "  fullname='$fullname'"
    [ "$debug" -eq 1 ] && echo "  filename='$filename'"

    if [ ! -e "$filename".smi ]; then

      # find its corresponding .smi file

      substr=$(echo "$fullname" | cut -d'.' -f $key)	# get the matching key
      [ "$debug" -eq 2 ] && echo "  key='$substr'"

      find *.smi -type f | while read smifile; do

        if [[ "$smifile" == *"$substr"* ]]; then	# find a matched smi file
          [ "$debug" -eq 2 ] && echo "  smifile='$smifile'"
          [ "$debug" -eq 3 ] && echo " Rename to '$filename'.smi"
          [ "$debug" -eq 3 ] && mv "$smifile" "$filename".smi
	  break
	fi

      done

      #echo "$filename".smi
    fi

    # mv "$fullname" "$filename"
    [ "$debug" -ne 0 ] && echo

  done

  shift;

done

exit 0
