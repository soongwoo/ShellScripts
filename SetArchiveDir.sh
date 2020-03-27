#!/bin/bash
#
# Check whether all files in the source drive directories in the target drive.
#

OPTION="[-debug=0] [tag=A]"
USAGE="Usage: $0 $OPTION md5-file"

tag=A
md5="NONE"
debug=0

# compare files and directories
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

# main function
olddir=""
cat "$md5" | while read line; do

  # get <dir>/<file name>
  arg=${line##*\*};
  [ "$debug" -eq 1 ] && echo "$arg"

  # extract dir name
  newdir=${arg%\/*};
  [ "$debug" -eq 2 ] && echo "$newdir"

  # rename the dir only if it is a new dir
  if [ "$olddir" != "$newdir" ]; then
    olddir="$newdir";
    echo "$tag"."$newdir";
    [ "$debug" -eq 0 ] && mv "$newdir" "$tag"."$newdir"
  fi

done

exit 0
