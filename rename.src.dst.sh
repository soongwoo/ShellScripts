#!/bin/sh

#  Rename source file header to the corresponding file header.

OPTION=""
USAGE="Usage: $0 header-file source-file"

[ $# -ne 2 ] && echo "$USAGE" && exit 1

hdrfile=$1
srcfile=$2

# header-file prefix position and length
hdrpos=0
hdrlen=24

# source-file filename position
srcpos=14

cat "$hdrfile" | while read f; do

  # get the date string
  datestr=$(echo "$f" | cut -d'.' -f 3);

  # check whether there is same date file
  src=$(grep "$datestr" "$srcfile");
  [ $? -ne 0 ] && echo "No source file for '$datestr'" && continue

  # get head and tail for the new file name
  head=${f:hdrpos:hdrlen}; # echo "$head"
  tail=${src:srcpos};
  dst="$head""$tail";

  # rename source file to the new
  # [ -e "$src" ] && echo "'$dst'"
  [ ! -e "$dst" ] && mv "$src" "$dst"

done

