#!/bin/bash
#
# Check whether the given directory has one or more video files.
#
# Revisions:
#

OPTION="[-debug=0]"
USAGE="Usage: $0 $OPTION dir1 dir2 ... dirN"

# initialize variables with default value
debug=1

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
  elif [ ! -d "$1" ]; then
    echo "'$1' is not a directory!"
    continue
  fi

  echo "Check '$1' ..."
  srcdir="$1"                 # source directory

  find "$srcdir"/* -type f | while read fullname; do
    filename=$(basename "$fullname")   # extract filename
    ext=${filename##*.}                # get extension
    filename=${filename%.*}            # remove extension

    if [ "$debug" -ne 0 ]; then
      echo "  fullname='$fullname'"
      echo "  filename='$filename'"
      echo "  ext='$ext'"
      echo
    fi
  done

  shift;

done

exit 0
