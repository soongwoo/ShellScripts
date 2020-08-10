#!/bin/bash
#
# Check whether all files in the source drive directories in the target drive.
#

OPTION="-drv [-debug=0] [-tag=A]"
USAGE="Usage: $0 $OPTION target-drive-letter"

tag=A
drv="NONE"
debug=0

# compare files and directories
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  else

    # check variables
    [ "$drv" == "NONE" ] && echo "NO DRIVE SPECIFIED!" && exit 1;
    
    i="$1";	# get the directory

    # skip $RECYCLE.BIN
    name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

    # skip 'System Volume Information'
    name=${i/System /}; [ "$i" != "$name" ] && continue;

    # compare files and directories
    if [ -e /cygdrive/"$drv"/"$i" ]; then

      echo "$i:";
      result=0;

      # compare all files in the directory
      find "$i"/* -type f | while read fname; do

        h=${fname%% *};		# remove after 1st blank
        f=${fname#$h*/};	# take off the directory name

        echo -n " $f";
        lval=$(diff "$i"/"$f" /cygdrive/"$drv"/"$i"/"$f");

        # can not set 'result' as 1!
        [ "$?" -ne 0 ] && result=1 && echo ": NOT COPIED" && exit 1;

        echo "";

      done

      echo "";

      # rename the source when the target is same as the source
      [ "$result" -eq 0 ] && mv "$i" "$tag"."$i";

    fi

  fi

  shift

done

exit 0
