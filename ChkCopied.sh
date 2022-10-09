#!/bin/bash
#
# Check whether the given arguments are copied.
#
# Any changes of a variable in sub-shell do not affect
# its values after sub-shell execution. So, the sub-shell
# section should be modified as the followings:
#
# Resolution One: using a while-loop
#====================================
# i=1
# while read x; do
#    i=$(($i + 1))
#    echo $i
# done <<<$(find tmp -type f)
# echo $i
#
# Resolution Two: using a for-loop:
#===================================
# i=1
# for x in $(find tmp -type f);
# do 
#    i=$(($i + 1))
#    echo $i
# done
# echo $i
#

OPTION="[-debug=0] [-tag=z] destination-drive source_(dir_i|file_i)"
USAGE="Usage: $0 $OPTION "

# check # of arguments
[ "$#" -lt 2 ] && echo "$USAGE" && exit 1;

# initialize variables
debug=0;
dst="";
tag="z";

# process the arguments
while (( "$#" )); do

  i="$1";	# readable

  # option argument
  if [ ${i:0:1} = '-' ]; then
    tmp=${i:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  # is it destination drive letter?
  elif [ -z "$dst" ]; then

    dst="/cygdrive/""$i";

    # check the drive
    [ ! -e "$dst" ] && echo "Invalid drive letter '$i'" && exit 1;

  # if it doesn't exist
  elif [ ! -e "$i" ]; then
    echo -e "\n'$i': Does not exist";

  # it's a file
  elif [ -f "$i" ]; then
    echo -en "\n$i: ";
    [ "$(diff "$i" "$dst"/"$i" &> /dev/null)" ] && echo "NOT COPIED" || echo "";

  # it's a directory
  elif [ -d "$dst"/"$i" ]; then

    # strip off '/' from at the end of string
    [ "${i: -1}" == '/' ] && i=${i:: -1};

    # neither '$RECYCLE.BIN' nor 'System Volume Information'
    if [ "$i" != "\$RECYCLE.BIN" -a "$i" != "System Volume Information" ]; then

      result=0;		# set the result
      echo -e "\n$i: ";	# show the progress

      # it's not an empty directory
      if [ "$(ls -A "$i")" ]; then 

        # scan all files but .md5
        IFS="$IFS"; IFS=$'\n';		# handle spaces in file name
	for f in $(find "$i"/* -type f); do

          rtn=0;	# yes, it's copied.

          ff=${f##$i/};		# do not print '$i/'

          echo -n " $ff: ";	# show the progress

          # it's a '.md5' file,
          if [ ${ff/.md5/} != "$ff" ]; then

            # update destination .md5 file
            if [ -f "$dst"/"$f" ]; then

              cat "$f" >> "$dst"/"$f";
              tmpfile=$(mktemp /tmp/script.XXXXXX);

              sort -k 2 -u "$dst"/"$f" > "$tmpfile"; # remove duplicate lines and sort
              mv "$tmpfile" "$dst"/"$f";

            fi; # update destination .md5 file

          # not .md5 file
          else
            [ "$(diff "$f" "$dst"/"$f" &> /dev/null)" ] && rtn=1;

          fi; # it's a '.md5' file,

          if [ "$rtn" -eq 0 ]; then echo ""; else echo "NOT COPIED"; result=1; fi;

        done;

      fi; # it's not an empty directory

      # if the source is copied
      [ "$result" -eq 0 ] && mv "$i" "$tag"."$i" || echo "$i: NOT COPIED";

    fi;	# neither '$RECYCLE.BIN' nor 'System Volume Information'

  fi;

  shift;

done;

exit 0;
