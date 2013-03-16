#!/bin/sh

# Check pre-calculated file's md5sum in the given file

OPTION=""
USAGE="Usage: $0 md5sum-file"

# check the number of argument
[ $# -ne 1 ] && echo "$USAGE" && exit 1

# initialize variables
MD5FILE=$1
CHECKSUM=md5sum
OUTPUT="./output.md5"
[ ! -e "$OUTPUT" ] && touch "$OUTPUT"   # create it if it does not exist

# main function
cat $MD5FILE | while read line; do

  # ignore if the file does not exist
  fname=${line:34};
  [ ! -e "$fname" ] && continue

  # calculate md5sum and show the result after comparing the md5sum values
  val1=${line/\ \**/};
  if [ -d "$fname" ]; then
    val2=$(tar c "$fname" | $CHKSUM | grep --only-matching -m 1 '^[0-9a-z]*')
  else
    val2=$($CHECKSUM "$fname" | grep --only-matching -m 1 '^[0-9a-z]*')
  fi

  # show the result
  if [ "$val1" = "$val2" ]; then
    echo "'$fname': OK"
    echo "$line" >> "$OUTPUT"
  else
    echo "'$fname': NO"
  fi

done

