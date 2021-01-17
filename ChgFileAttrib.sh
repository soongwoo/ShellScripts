#!/bin/bash
#
# Change the given argument's attribute.
# - directory attrib as 0755
# - file attrib as 0644
#

OPTION="[-debug=0] [-dattr=755] [-fattr=644] (dir_i|file_i)+"
USAGE="Usage: $0 $OPTION "

# check # of arguments
[ "$#" -lt 1 ] && echo "$USAGE" && exit 1;

debug=0
dattr=755
fattr=644

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
    echo "Unknown file or directory: '$i'";

  # it's an argument
  else

    echo "$i";		# show the progress

    # strip off '/' from at the end of string
    lc=${i: -1 }; [ "$lc" == '/' ] && i=${i::-1};

    # neither '$RECYCLE.BIN' nor 'System Volume Information'
    if [ "$i" != "\$RECYCLE.BIN" -a "$i" != "System Volume Information" ]; then

      # it's a directory
      if [ -d "$i" ]; then

        chmod "$dattr" "$i";	# change '$i' directory attribute

	# process its sub-directories and files
        find "$i"/* | while read f; do
          if [ -d "$f" ]; then
            chmod "$dattr" "$f"; [ "$debug" -ne 0 ] && echo " $i/$f";
          elif [ -f "$f" ]; then
            chmod "$fattr" "$f"; [ "$debug" -ne 0 ] && echo " $i/$f";
          fi
        done

      # it's a file
      else
        chmod "$fattr" "$i"; [ "$debug" -ne 0 ] && echo " $i";
      fi

    fi # neither '$RECYCLE.BIN' nor 'System Volume Information'

  fi

  shift

done

[ "$debug" -ne 0 ] && echo "dattr=$dattr fattr=$fattr"

exit 0
