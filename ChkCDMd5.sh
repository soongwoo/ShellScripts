#!/bin/sh

# Check md5 files for its subdirectories and files in root directory in the given CD directories.

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
    echo ""
    echo "$1: Check its integrity with md5sum ..."

    cd "$1"

    # do directories first
    find * -type d | while read dname; do
      echo "Check $1/$dname:"
      cd "$dname"
      md5sum -c "$dname".md5
      cd ..
      echo ""
    done

    # do check files in root directory
    echo "Check files:"
    md5sum -c "$1".md5  # specify md5 filename

    cd "$curdir"

  # what is it?
  else
    echo ""
    echo "$1: not a directory!"
  fi

  shift

done
