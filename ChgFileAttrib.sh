#!/bin/bash
#
# Change the attribute of all directories and files in current drive.
# - directory attrib as 0770
# - file attrib as 700
# NEED TO UNDERSTAND FILE ATTRIBUTE IN WINDOWS 10
#

OPTION="[-debug=0] [-dattr=755] [-fattr=644]"
USAGE="Usage: $0 $OPTION"

debug=0
dattr=755
fattr=644

# compare files and directories
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value
  else
    echo "$USAGE" && exit 1
  fi

  shift

done

[ "$debug" -ne 0 ] && echo "dattr=$dattr fattr=$fattr"

# main function
ndir=0
nfile=0

for i in *; do

  # skip $RECYCLE.BIN
  name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System /}; [ "$i" != "$name" ] && continue;

  echo "$i";	# show the progress

  if [ -d "$i" ]; then

    [ "$debug" -ne 0 ] && (( ndir++ ));		# increment directory counter

    chmod "$dattr" "$i";	# change directory attribute

    cd "$i";
    find * | while read f; do
      if [ -d "$f" ]; then
        chmod "$dattr" "$f"
        [ "$debug" -ne 0 ] && echo " $i/$f";
      else
        chmod "$fattr" "$f"
        [ "$debug" -ne 0 ] && echo " $f";
      fi
    done
    cd ..;

  else 

    chmod "$fattr" "$i"
    [ "$debug" -ne 0 ] && (( nfile++ ));

  fi

done

[ "$debug" -ne 0 ] && echo "ndir=$ndir nfile=$nfile"

exit 0
