#!/bin/bash
#
# Simply take off current extention.
#
# Revisions:
#

OPTION="[-debug=0]"
USAGE="Usage: $0 $OPTION file1 file2 ... fileN"

# initialize variables with default value
debug=0

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

  fullname="$1"

  filename=$(basename "$fullname")   # extract filename
  ext=${filename##*.}                # get extension
  filename=${filename%.*}            # remove extension

  [ "$debug" -eq 1 ] && echo "  fullname='$fullname'"
  [ "$debug" -eq 1 ] && echo "  filename='$filename'"
  [ "$debug" -eq 1 ] && echo "  ext='$ext'"
  [ "$debug" -eq 2 ] && echo "  mv '$fullname' '$filename'"

  echo " Take off '.$ext' from '$fullname'"
  mv "$fullname" "$filename"
  [ "$debug" -ne 0 ] && echo

  shift;

done

exit 0
