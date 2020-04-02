#!/bin/sh

# List the subdirectories of the given drive.

OPTION="[-debug=0]"
USAGE="Usage: $0 drive1 drive2 ... driveN"

[ $# -lt 1 ] && echo "$USAGE" && exit 1

#initialize variables
debug=0
curdir=$(pwd)

while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  else

    drv="$1";
    [ "$debug" -ne 0 ] && echo "$drv";

    [ ! -f /cygdrive/"$drv" ] && echo "'drive $drv' does not exist!" && exit 2

    cd "$drv":;		# change to the target drive

    # check all directories in the drive
    for i in *; do

      # skip $RECYCLE.BIN
      name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

      # skip 'System Volume Information'
      name=${i/System /}; [ "$i" != "$name" ] && continue;

      [ "$debug" -ne 0 ] && echo "$i";

      [ ! -d "$i" ] && continue;

      # check whether it is one or more subdirectories
      nsubdir=`find "$i" -maxdepth 1 -type d | wc -l`;

      [ "$nsubdir" -ne 1 ] && echo "$i: $nsubdir subdirectories"

    done

  fi

  shift

done

cd "$curdir";

exit 0
