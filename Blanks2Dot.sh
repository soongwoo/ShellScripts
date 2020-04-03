#!/bin/bash
#
# Convert blanks to a single dor in file name or direcroty name.
#

OPTION="[-debug=0]"
USAGE="Usage: $0 $OPTION"

debug=0

# main function
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

len=0;	# length of previous output

for i in *; do

  printf "%*s\r" "$len" " ";	# erase previous output with blanks
  echo -en "$i\r";		# print current file name
  len=${#i};			# length of current output

  # skip $RECYCLE.BIN
  name=${i/\$RECYCLE.BIN/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System Volume Information/}; [ "$i" != "$name" ] && continue;

  # convert blanks to a dot
  name=$(echo "$i" | sed 's/  */\./g');
  if [ "$name" != "$i" ]; then
    [ "$debug" -ne 0 ] && echo "$i";
    [ "$debug" -eq 0 ] && echo "$name";
    [ "$debug" -eq 0 ] && mv "$i" "$name";
  fi

  if [ -d "$name" ]; then
    for old in "$name"/*; do
      f=$(echo "$old" | sed 's/  */\./g');

      if [ "$old" != "$f" ]; then
        [ "$debug" -ne 0 ] && echo "$f";
        [ "$debug" -eq 0 ] && echo "$old";
        [ "$debug" -eq 0 ] && mv "$old" "$f";
      fi

    done
  fi

done

printf "%*s" "$len" " ";

exit 0
