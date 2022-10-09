#!/bin/sh

# Run "md5sum -c *md5" command in the given directory.

OPTIONS="[-debug=0]"
USAGE="Usage: $0 $OPTIONS (dir_i)"

[ $# -lt 1 ] && echo "$USAGE" && exit 1

# initialize variables
debug=0;
wd=$(pwd);

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
    echo -e "\n'$i': Does not exist";

  # it's a file
  elif [ ! -d "$i" ]; then
    echo -e "\n'$i': Not a directory";

  # not empty directory
  elif [ "$(ls -A "$i")" ]; then

  # it's a directory
  else

    # strip off '/' from at the end of string
    [ "${i: -1}" == '/' ] && i=${i:: -1};

    # neither '$RECYCLE.BIN' nor 'System Volume Information'
    if [ "$i" != "\$RECYCLE.BIN" -a "$i" != "System Volume Information" ]; then

      # check video file's descrition text
      if [ ! -e "$i"/"$i".md5 ]; then
        echo -e "\n'$i': no md5 file!";
      else
        echo -e "\n'$i': Check its integrity with md5sum ...";

        cd "$i";
        md5sum -c "$i".md5;	# check md5sum in the file
        cd "$wd";
      fi;

    fi;	# neither '$RECYCLE.BIN' nor 'System Volume Information'

  fi;

  shift;

done;

exit 0;
