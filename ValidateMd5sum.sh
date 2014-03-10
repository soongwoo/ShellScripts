#!/bin/sh

# Check pre-calculated file's md5sum in the given file

OPTION="[-listonly=off|on]"
USAGE="Usage: $0 $OPTION md5sum-file"

# initialize variables
MD5FILE=""
CHECKSUM=md5sum
OUTPUT="./output.md5"

# check the arguments
listonly="off"
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value
  else
    MD5FILE="$1"
  fi

  shift

done

# check the $MD5FILE argument
[ -z "$MD5FILE" ] && echo "$USAGE" && exit 1

# main function
[ ! -e "$OUTPUT" ] && touch "$OUTPUT"   # create it if it does not exist
cat "$MD5FILE" | while read line; do

  # ignore if the file does not exist
  fname=${line:34};
  [ ! -e "$fname" ] && continue

  # if listonly flag is on, then print the file name
  [ "$listonly" == "on" ] && echo "$fname"  && continue

  # calculate md5sum and show the result after comparing the md5sum values
  val1=${line/\ \**/};
  val2=$($CHECKSUM "$fname" | grep --only-matching -m 1 '^[0-9a-z]*')

  # show the result
  if [ "$val1" = "$val2" ]; then
    echo "'$fname': OK"
    echo "$line" >> "$OUTPUT"
  else
    echo "'$fname': NO"
    break;
  fi

done
