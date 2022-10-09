#!/bin/bash
#
# Change the given argument's ownership.
# - owner:Home
# - group:None
#

OPTION="[-debug=0] [-owner=Home] [-group=None] (dir_i|file_i)+"
USAGE="Usage: $0 $OPTION "

# check # of arguments
[ "$#" -lt 1 ] && echo "$USAGE" && exit 1;
USAGE="Usage: $0 $OPTION"

debug=0
owner=Home
group=None

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

      chown -R "$owner":"$group" "$i";	# change directory attribute

    fi # neither '$RECYCLE.BIN' nor 'System Volume Information'

  fi

  shift

done

[ "$debug" -ne 0 ] && echo "owner=$owner group=$group"

exit 0
