#!/bin/sh

# Run "md5sum -c *md5" command in the given directory.

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
    md5sum -c *md5
    cd "$curdir"

  # what is it?
  else
    echo ""
    echo "$1: not a directory!"
  fi

  shift

done
