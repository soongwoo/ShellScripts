#!/bin/bash
#
# List directory which doesn't have a description file,
#

OPTIONS="[-debug=0]"
USAGE="Usage: $0 $OPTIONS (dir_i)"

[ $# -lt 1 ] && echo "$USAGE" && exit 1

# initialize variables
debug=0;

# process the arguments
while (( "$#" )); do

  i="$1";		# make it more readable

  # option argument
  if [ ${i:0:1} = '-' ]; then
    tmp=${i:1};			# strip off leading '-'
    parameter=${tmp%%=*};	# extract name
    value=${tmp##*=};		# extract value
    eval $parameter=$value;

  # if it doesn't exist
  elif [ ! -e "$i" ]; then
    echo "Unknown file or directory: '$i'";

  # it's a file
  elif [ ! -d "$i" ]; then
    echo "Not a directory: '$i'";

  # it's a directory
  else

    # strip off '/' from at the end of string
    lc=${i: -1}; [ "$lc" == '/' ] && i=${i::-1};

    # neither '$RECYCLE.BIN' nor 'System Volume Information'
    if [ "$i" != "\$RECYCLE.BIN" -a "$i" != "System Volume Information" ]; then

      # check video file's descrition text
      [ ! -e "$i"/"$i".txt ] && echo "$i";

    fi;	# neither '$RECYCLE.BIN' nor 'System Volume Information'

  fi;

  shift;

done;

exit 0;
