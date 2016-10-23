#!/bin/bash
#
# Compare files and directories in two drives.
#

USAGE="Usage: $0 targetDrive"

[ $# -lt 1 ] && echo "$USAGE" && exit 1

drv="$1";

# compare files and directories
for i in *; do

  # skip $RECYCLE.BIN
  name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System /}; [ "$i" != "$name" ] && continue;

  # compare files and directories
  echo "$i";
  if [ -d "$i" ]; then
    diff -r "$i" /cygdrive/"$drv"/"$i";
  else
    diff "$i" /cygdrive/"$drv"/"$i";
  fi

done

exit 0
