#!/bin/bash
#
# Convert UTF-8 with BOM file to UTF-8.
# - sed -i '1s/^\xEF\xBB\xBF//' orig.txt
#

OPTION=""
USAGE="Usage: $0 $OPTION"

# compare files and directories
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value
  fi

  shift

done

# main function
for i in *; do

  # skip $RECYCLE.BIN
  name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

  # skip 'System Volume Information'
  name=${i/System /}; [ "$i" != "$name" ] && continue;

  echo "$i";		# show the progress

  if [ -d "$i" ]; then

    # convert all text files under the directory
    cd "$i";

    # convert text files only
    find * -type f | while read f; do
      x=${f%.txt};
      [ "$f" != "$x" ] && echo " $f" && sed -i '1s/^\xEF\xBB\xBF//' "$f";
    done

    cd ..;

  else
    f=${i%.txt};
    [ "$f" != "$i" ] && sed -i '1s/^\xEF\xBB\xBF//' "$i";
  fi

  echo "";

done

exit 0
