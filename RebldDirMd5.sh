#!/bin/bash
#
# Rebuild md5sum for the given directories in current drive.
#

OPTION="[-debug=0]"
USAGE="Usage: $0 $OPTION"

debug=0

# get current drive
curdir=$(pwd);		[ "$debug" -ne 0 ] && echo "$curdir";
curdrv=${curdir:10:1};	[ "$debug" -ne 0 ] && echo "$curdrv";

# move to the root of current drive
cd "$curdrv":;		[ "$?" -ne 0 ] && echo "Error: move to the root" && exit 1;

# compare files and directories
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}			# strip off leading '-'
    parameter=${tmp%%=*}	# extract name
    value=${tmp##*=}		# extract value
    eval $parameter=$value

  elif [ -d "$1" ]; then

    dname="$1";
    dname=${1%/}	# remove trailing slash char

    # skip $RECYCLE.BIN
    i=${dname/\$RECYCLE.BIN/}; [ "$dname" != "$i" ] && continue;

    # skip 'System Volume Information'
    i=${dname/System Volume Information/}; [ "$dname" != "$i" ] && continue;

    echo "$dname";

    # prepare new directory
    rm -f "$i"/"$i".md5;	[ "$?" -ne 0 ] && echo "'$i.md5' delete error" && exit 1;
    mv "$i" "$i".a;		[ "$?" -ne 0 ] && echo "'$i'.a move error" && exit 1;
    mkdir "$i";			[ "$?" -ne 0 ] && echo "'$i' create error" && exit 1;
    mv "$i".a/* "$i"/.;		[ "$?" -ne 0 ] && echo "'$i'/* move error" && exit 1;
    rm -r "$i".a;		[ "$?" -ne 0 ] && echo "'$i'.a delete error" && exit 1;

  fi

  shift

done

exit 0
