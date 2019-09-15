#!/bin/bash
#
# Rename archived directories by padding "A." at the beginning.
#

USAGE="Usage: $0 target-drive-letter"

[ $# -lt 1 ] && echo "$USAGE" && exit 1

[ $# -gt 1 ] && echo "$USAGE" && exit 1

for i in *; do

  # skip if it is not a directory
  [ ! -d "$i" ] && continue;

  # skip $RECYCLE.BIN
  name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System /}; [ "$i" != "$name" ] && continue;

  # check video file's descrition text
  [ -d "$1"/"$i" ] && echo "$i" && mv "$i" A."$i";

done

exit 0
