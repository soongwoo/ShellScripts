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

OPTION="[-debug=0] [-tag=A] destination-drive source_(dir_i|file_i)"
USAGE="Usage: $0 $OPTION "

# check # of arguments
[ "$#" -lt 2 ] && echo "$USAGE" && exit 1;

# initialize variables
debug=0;
dst="";
tag="A";

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
    echo "Source: Unknown file or directory '$i'";

  # if it doesn't exist
  elif [ ! -e "$dst"/"$i" ]; then
    echo "'$i': NOT COPIED";

  # it's a file
  elif [ -f "$i" ]; then
    diff "$i" "$dst"/"$i" &> /dev/null;
    if [ "$?" -eq 0 ]; then echo "$i: Copied"; else echo -e "$i: NOT COPIED"; fi;

  # it's a directory
  else

    # strip off '/' from at the end of string
    lc=${i: -1}; [ "$lc" == '/' ] && i=${i::-1};

    # neither '$RECYCLE.BIN' nor 'System Volume Information'
    if [ "$i" != "\$RECYCLE.BIN" -a "$i" != "System Volume Information" ]; then

#         wd=$(pwd);	# save the retun point
#
# Use '.md5' in source directory
#         ii=$(readlink -f "$i");		# get full path name of $i
#         cd "$dst"/"$i";
#         rtn=$(md5sum -c "$ii"/*md5 &> /dev/null);
#         [ "$?" -ne 0 ] && result=0;
#         cd "$wd";

      result=0;		# set the result
      echo -e "\n$i: ";	# show the progress

      # scan all files but .md5
      IFS="$IFS"; IFS=$'\n';		# handle spaces in file name
      for f in $(find "$i"/* -type f); do

        ff=${f##$i/};		# do not print '$i/'

        echo -n " $ff: ";	# show the progress

        diff "$f" "$dst"/"$f" &> /dev/null;
        if [ "$?" -eq 0 ]; then rtn=0; else rtn=1; fi;

        # it's a '.md5' file,
        if [ "$rtn" -ne 0 -a ${ff/.md5/} != "$ff" ]; then

          rtn=0;	# yes, it's copied.

          if [ -f "$dst"/"$f" ]; then
            diff "$f" "$dst"/"$f" &> /dev/null;
            [ "$?" -ne 0 ] && cat "$f" >> "$dst"/"$f";

            # remove duplicate lines and sort
            tmpfile=$(mktemp /tmp/script.XXXXXX);
            sort -k 2 -u "$dst"/"$f" > "$tmpfile";
            mv "$tmpfile" "$dst"/"$f";
          fi;

        fi;

        if [ "$rtn" -eq 0 ]; then echo ""; else echo "NOT COPIED"; result=1; fi;

      done;

      # if the source is copied
      [ "$result" -eq 0 ] && mv "$i" "$tag"."$i";

    fi;	# neither '$RECYCLE.BIN' nor 'System Volume Information'

  fi;

  shift;

done;

exit 0;
