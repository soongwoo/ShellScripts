#!/bin/bash
#
# Change the ownership for all directories and files in current drive.
# - owner:Home
# - group:None
#

OPTION="[-owner=Home] [-group=None]"
USAGE="Usage: $0 $OPTION"

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
  fi

  shift

done

echo "owner=$owner group=$group"

# main function
ndir=0
nfile=0
for i in *; do

  # skip $RECYCLE.BIN
  name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System /}; [ "$i" != "$name" ] && continue;

  echo "$i";	# show the progress

  chown "$owner":"$group" "$i";	# change directory attribute
  if [ -d "$i" ]; then
    (( ndir++ ));			# increment directory counter
    chown -R "$owner":"$group" "$i"/*;	# change files attribute in the directory
  else
    (( nfile++ ));			# increment directory counter
  fi

done

exit 0
