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

    [ ! -e "$i"/"$i".md5 ] && echo " NO MD5" && echo "" && continue;

    # convert all text files under the directory
    cd "$i";

    # replace md5sum for the txt files in "$i".md5
    grep ".txt" "$i".md5 | while read line; do
      oldmd5=$(echo "$line" | head -n1 | cut -d " " -f1);
      f=${line#$oldmd5 \*};

      # no file, then remove the line from "$i".md5
      [ ! -e "$f" ] && sed -i "/$f/d" "$i".md5 && echo " REMOVE:$f" && continue;

      # replace with new md5 value
      echo " $f";
      result=$(md5sum "$f");
      newmd5=$(echo "$result" | head -n1 | cut -d " " -f1);
      [ "$oldmd5" != "$newmd5" ] && sed -i "s/$oldmd5/$newmd5/g" "$i".md5;
    done

    cd ..;

  fi

  echo "";

done

exit 0
