#!/bin/bash
#
# Convert blanks to a single dot in file name or direcroty name.
#

OPTION="[-debug=0] (dir_i|file_i)+"
USAGE="Usage: $0 $OPTION "

# check # of arguments
[ "$#" -lt 1 ] && echo "$USAGE" && exit 1;

debug=0

# main function
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

    [ "$debug" -ne 0 ] && echo "argument='$i'";

    # strip off '/' from at the end of string
    lc=${i: -1 }; [ "$lc" == '/' ] && i=${i::-1};

    # extract the name only
    f=${i##*/};
    [ "$debug" -eq 0 ] && echo "name='$f'";

    # neither '$RECYCLE.BIN' nor 'System Volume Information'
    if [ "$f" != "\$RECYCLE.BIN" -a "$f" != "System Volume Information" ]; then

      # initialze variables
      lc="";		# last character
      len=${#f};	# string length
      s="";		# new filename

      # scan the string to handle blanks
      for (( l=0; l < len; l++ )) {

	# get the next char
	c=${f:l:1};

	# if it's not a consecutive blank char
	if [ "$c" != ' ' ]; then
          s="$s""$c";
	elif [ "$lc" != ' ' ]; then
          s="$s"".";
        fi

	# update the variables
	lc="$c";

        [ "$debug" -ne 0 ] && echo "$l='$c' s='$s'";
      }

      # strip off '.' from at the end of new filename
      lc=${s: -1 }; [ "$lc" == '.' ] && s=${s::-1};

      [ "$debug" -ne 0 ] && echo "s='$s'";

      # rename the '$f' if it's changed
      if [ "$f" != "$s" ]; then

        # make a fullname
	newname="$s";
	d=${i%/*};	# dirname
	[ "$i" != "$d" ] && newname="$d"/"$s";

        # rename it if necessary
	result=$(mv "$i" "$newname");
        [ "$?" -ne 0 ] && echo "Error: mv '$i' '$newname'";
      fi

    fi # neither '$RECYCLE.BIN' nor 'System Volume Information'

  fi

  shift

done

exit 0
