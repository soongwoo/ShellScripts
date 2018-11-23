#!/bin/bash
#
# Check (Movie/Drama/Music/CD) copied directories.
#
# Revisions:
#

OPTION="[-debug=0] [-seconds=0] [-class=Movie|Drama|Music|CD]"
USAGE="Usage: $0 $OPTION SOURCE DEST"

# initialize variables with default value
debug=0
seconds=0
class="Movie"
SRC=""
DST=""

# do main task
[ $# -eq 0 ] && echo "$USAGE" && exit 1;

count=0
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1};              # strip off leading '-'
    parameter=${tmp%%=*};    # extract name
    value=${tmp##*=};        # extract value
    eval $parameter=$value;

  # get the SOURCE argument
  elif [ "$SRC" == "" ]; then
    SRC="$1";

  # get the DEST argument
  elif [ "$SRC" != "" -a "$DST" == "" ]; then
    DST="$1";

  # too many argument
  else
    echo "'$1': Too many argument";
    exit 2;

  fi

  shift;

done

# verify the arguments
[ "$SRC" == "" ] && echo "No SOURCE argument" && exit 3;
[ "$DST" == "" ] && echo "No DEST argument" && exit 4;
[ "$class" != "Movie" -a "$class" != "Drama" -a "$class" != "Music" -a "$class" != "CD" ] && echo " Unknown class(='$class')" && exit 5;
[ "$seconds" -lt 0 ] && echo "Invalid seconds='$seconds'" && exit 6;

[ "$debug" -eq 1 ] && echo " SOURCE='$SRC'"
[ "$debug" -eq 1 ] && echo " DEST='$DST'"
[ "$debug" -eq 1 ] && echo " class='$class'"
[ "$debug" -eq 1 ] && echo " seconds='$seconds'"

# sleep with the given seconds
[ "$seconds" -gt 0 ] && date && echo "  Compare '$class' after sleeping $seconds(secs) ..." && sleep "$seconds" && echo;

# compare directories
for fullsrc in "$SRC"/"$class".*; do

  file=${fullsrc#$SRC/};	# get the file name
  [ "$debug" -eq 2 ] && echo "filename='$file'";

  # compare the source and the destination
  fulldst="$DST"/"$file"
  if [ -d "$fulldst" ]; then

    date;
    echo "$fullsrc ..."
    diff -r "$fullsrc" "$fulldst"
    echo

  fi

done

exit 0
