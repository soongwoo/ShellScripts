#!/bin/bash
#
# Change the ownership for all directories and files in current drive.
# - owner:Home
# - group:None
#

OPTION="[-debug=0] [-owner=Home] [-group=None]"
USAGE="Usage: $0 $OPTION"

debug=0
owner=Home
group=None

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

[ "$debug" -ne 0 ] && echo "owner=$owner group=$group"

# main function
ndir=0
nfile=0

for i in *; do

  # skip $RECYCLE.BIN
  name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System /}; [ "$i" != "$name" ] && continue;

  echo "$i";	# show the progress

  chown -R "$owner":"$group" "$i";	# change directory attribute
  if [ -d "$i" ]; then
    (( ndir++ ));			# increment directory counter
  else
    (( nfile++ ));			# increment directory counter
  fi

done

[ "$debug" -ne 0 ] && echo "ndir=$ndir nfile=$nfile"

exit 0
