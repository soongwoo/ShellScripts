#!/bin/sh

# List the subdirectories of the given directories.

OPTION="[-mode=debug]"
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

    echo ""
    echo "$1:"

    find "$1"/* -type d | while read subdir; do
      dname=${subdir#$1}	# remove the directory name
      echo "  ${dname:1}"	# remove the first char, '/'
    done

  # what is it?
  else
    echo ""
    echo "$1: not a directory!"
  fi

  shift

done
