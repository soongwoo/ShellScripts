#!/bin/bash
#
# Compare files and directories in two drives.
#

# compare files and directories
for i in *; do

  # skip $RECYCLE.BIN
  name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System /}; [ "$i" != "$name" ] && continue;

  # compare files and directories
  echo "$i";
  if [ -d "$i" ]; then
    diff -r "$i" /cygdrive/n/"$i";
  else
    diff "$i" /cygdrive/n/"$i";
  fi

done

exit 0
