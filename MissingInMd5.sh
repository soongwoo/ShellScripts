#!/bin/sh

# List missing files, which are in the given md5sum file.

OPTION=""
USAGE="Usage: $0 md5sum-file"

# check the number of argument
[ $# -ne 1 ] && echo "$USAGE" && exit 1

# initialize variables
MD5FILE="$1"
CHECKSUM=md5sum
OUTPUT="./missing.txt"
#[ ! -e "$OUTPUT" ] && touch "$OUTPUT"   # create it if it does not exist

# main function
cat "$MD5FILE" | while read line; do

  # ignore if the file does not exist
  fname=${line:34};
  if [ ! -e "$fname" ]; then
    echo "$fname"
  fi

done
