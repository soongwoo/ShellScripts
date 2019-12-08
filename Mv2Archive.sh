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

  # check the directory integrity and append "A." in the directory name
  if [ -d /cygdrive/"$1"/"$i" ]; then
    echo -n "$i";
    result=$(diff -r "$i" /cygdrive/"$1"/"$i");
    if [ "$?" -eq 0 ]; then
      mv "$i" A."$i";
    else
      echo -n ": NO"
    fi
    echo "";
  fi

done

exit 0
