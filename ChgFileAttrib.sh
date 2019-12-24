#!/bin/bash
#
# Change the attribute of all directories and files in current drive.
# - directory attrib as 0770
# - file attrib as 644.
#

OPTION="[-dattr=770] [-fattr=700]"
USAGE="Usage: $0 $OPTION"

dattr=770
fattr=700

# compare files and directories
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value
  fi

  shift

done

echo "dattr=$dattr fattr=$fattr"

# main function
ndir=0
nfile=0
for i in *; do

  # skip $RECYCLE.BIN
  name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System /}; [ "$i" != "$name" ] && continue;

  if [ -d "$i" ]; then
    (( ndir++ ));		# increment directory counter
    chmod "$dattr" "$i";	# change directory attribute

    # check whether it is one or more subdirectories
    nsubdir=`find "$i" -maxdepth 1 -type d | wc -l`;

    if [ "$nsubdir" -ne 1 ]; then
      echo "$i: check subdirectories"

    else # no subdirectories
      echo "$i";
      chmod "$fattr" "$i"/*
    fi

  else 
    (( nfile++ ));

    chmod "$fattr" "$i"

  fi

done

exit 0
