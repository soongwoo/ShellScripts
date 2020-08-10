#!/bin/sh

# Run "md5sum -c *md5" command in the given directory.

OPTION="[-debug=0]"
debug=0
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

    dname=${1%/}		# remove trailing slash char

    if [ ! -e "$dname"/"$dname".md5 ]; then
      echo -e "\n'$dname': no md5 file!"
    else
      echo -e "\n'$dname': Check its integrity with md5sum ..."

      cd "$1"
      md5sum -c "$dname".md5	# specify md5 filename
      cd "$curdir"
    fi

  # what is it?
  else
    echo -e "\n'$1': not a directory!"
  fi

  shift

done
