#!/bin/bash
#
# Rebuild md5sum for all directories in current drive.
#

OPTION="[-debug=0]"
USAGE="Usage: $0 $OPTION"

debug=0

# compare files and directories
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value
  else
    echo "Unknown argument: '$1'"
  fi

  shift

done

# get current drive
curdir=$(pwd);		[ "$debug" -ne 0 ] && echo "$curdir";
curdrv=${curdir:10:1};	[ "$debug" -ne 0 ] && echo "$curdrv";

# move to the root of current drive
cd "$curdrv":;		[ "$?" -ne 0 ] && echo "Error: move to the root" && exit 1;

# main function
for i in *; do

  # skip $RECYCLE.BIN
  name=${i/\$RECYCLE.BIN/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System Volume Information/}; [ "$i" != "$name" ] && continue;

  echo "$i";

  # prepare new directory
  rm -f "$i"/"$i".md5;		[ "$?" -ne 0 ] && echo "'$i.md5' delete error" && exit 1;
  mv "$i" "$i".a;		[ "$?" -ne 0 ] && echo "'$i'.a move error" && exit 1;
  mkdir "$i";			[ "$?" -ne 0 ] && echo "'$i' create error" && exit 1;
  mv "$i".a/* "$i"/.;		[ "$?" -ne 0 ] && echo "'$i'/* move error" && exit 1;
  rm -r "$i".a;			[ "$?" -ne 0 ] && echo "'$i'.a delete error" && exit 1;

done

exit 0
