#!/bin/bash
#
# Change the given argument's attribute.
# - directory attribute as 0770
# - file attribute as 0770
#

OPTION="[-debug=0] [-dattr=770] [-fattr=770] (dir_i|file_i)+"
USAGE="Usage: $0 $OPTION "

# check # of arguments
[ "$#" -lt 1 ] && echo "$USAGE" && exit 1;

debug=0
dattr=770
fattr=770

# process the arguments
while (( "$#" )); do

  i="$1";

  # option argument
  if [ ${i:0:1} = '-' ]; then
    tmp=${i:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  # if it doesn't exist
  elif [ ! -e "$i" ]; then
    echo -e "\n'$i': Does not exist";

  # it's an argument
  else

    # strip off '/' from at the end of string
    [ "${i: -1}" == '/' ] && i=${i:: -1};

    # neither '$RECYCLE.BIN' nor 'System Volume Information'
    if [ "$i" != "\$RECYCLE.BIN" -a "$i" != "System Volume Information" ]; then

      echo "$i";		# show the progress

      # it's a file
      if [ -f "$i" ]; then
        chmod "$fattr" "$i"; [ "$debug" -ne 0 ] && echo " $i";

      # it's a directory
      else

        chmod "$dattr" "$i";	# change '$i' directory attribute

        # not empty directory
	# process its sub-directories and files
        if [ "$(ls -A "$i")" ]; then
          find "$i"/* | while read f; do
            if [ -d "$f" ]; then
              chmod "$dattr" "$f"; [ "$debug" -ne 0 ] && echo " $i/$f";
            elif [ -f "$f" ]; then
              chmod "$fattr" "$f"; [ "$debug" -ne 0 ] && echo " $i/$f";
            fi
          done
	fi;

      fi # it's a directory

    fi # neither '$RECYCLE.BIN' nor 'System Volume Information'

  fi

  shift

done

[ "$debug" -ne 0 ] && echo "dattr=$dattr fattr=$fattr"

exit 0
