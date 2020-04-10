#!/bin/bash
#
# Set source directory in the given md5 file
# be archived when it exists in destination drive.
#

OPTION="[-debug=0] [-tag=A] [-dst=NONE]"
USAGE="Usage: $0 $OPTION md5-file"

tag=A
md5="NONE"
dst="NONE"
debug=0

# parse the arguments
# BUG: MULTIPLE OPTIONS CAN BE defined.
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  elif [ "$md5" == "NONE" ]; then
     md5=$1
  else
    echo "Too many md5 specified"
  fi

  shift

done

# check variables
[ "$md5" == "NONE" ] && echo "No md5 file specified" && exit 1
[ "$dst" == "NONE" ] && echo "No drive specified" && exit 1
result=$(grep "/cygdrive/$dst" /proc/mounts);
[ "$?" -ne 0 ] && echo "'$dst' drive doesn't exist!" && exit 1

# get current drive
curdir=$(pwd);		[ "$debug" -ne 0 ] && echo "$curdir";
curdrv=${curdir:10:1};	[ "$debug" -ne 0 ] && echo "$curdrv";

# move to the root of current drive
cd "$curdrv":;		[ "$?" -ne 0 ] && echo "Error: move to the root" && exit 1;

# main function
olddir=""
cat "$md5" | while read line; do

  # get <dir>/<file name>
  arg=${line##*\*};
  [ "$debug" -eq 1 ] && echo "$arg"

  # extract dir name
  newdir=${arg%\/*};

  # rename the dir only if it is a new dir
  if [ "$olddir" != "$newdir" -a -d "$newdir" ]; then
    olddir="$newdir";
    [ "$debug" -eq 2 ] && echo "$newdir"
    if [ "$debug" -eq 0 -a -d /cygdrive/"$dst"/"$newdir" ]; then
      echo "$tag"."$newdir";
      mv "$newdir" "$tag"."$newdir";
    fi
  fi

done

exit 0
