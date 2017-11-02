#!/bin/bash
#
# Chech whether video file's description file exists in current drive,
#

USAGE="Usage: $0"

[ $# -gt 1 ] && echo "$USAGE" && exit 1

for i in *; do

  # skip if it is not a directory
  [ ! -d "$i" ] && continue;

  # skip $RECYCLE.BIN
  name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System /}; [ "$i" != "$name" ] && continue;

  # check video file's descrition text
  [ ! -e "$i"/"$i".txt ] && echo "$i";

done

exit 0
