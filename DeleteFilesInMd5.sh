#!/bin/sh

# Delete files, which are in the given md5sum file.

OPTION=""
USAGE="Usage: $0 md5sum-file"

# check the number of argument
[ $# -ne 1 ] && echo "$USAGE" && exit 1

# initialize variables
MD5FILE="$1"
CHECKSUM=md5sum
OUTPUT="./output.bat"
#[ ! -e "$OUTPUT" ] && touch "$OUTPUT"   # create it if it does not exist

# main function
cat "$MD5FILE" | while read line; do

  # ignore if the file does not exist
  fname=${line:34};
  if [ -e "$fname" ]; then
    # echo -e "del \"$fname\"\r\n" >> "$OUTPUT"
    echo "Delete '$fname' ..."
    rm "$fname"
  else
    echo "NO '$fname'"
  fi

done
