#!/bin/sh

# Compare ...

OPTION=""
USAGE="Usage: $0 directory target-drive"

[ $# -ne 2 ] && echo "$USAGE" && exit 1

for dirname in "$1"*; do

  [ ! -d "$dirname" ] && continue;

  [ ! -d /cygdrive/"$2"/"$dirname" ] && echo "NO '$dirname'" && continue;

  find "$dirname"/* -type f | while read fname; do
    [ ! -e /cygdrive/"$2"/"$fname" ] && echo "$fname"
  done;

done
