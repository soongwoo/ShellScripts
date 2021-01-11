#!/bin/bash
#
# Convert UTF-8 with BOM file to UTF-8.
# - sed -i '1s/^\xEF\xBB\xBF//' orig.txt
#

OPTION=""
USAGE="Usage: $0 $OPTION"

# compare files and directories
while (( "$#" )); do

  i="$1";	# set a variable

  # option argument
  if [ ${i:0:1} = '-' ]; then
    tmp=${i:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  elif [ -d "$i" ]; then

    name=${i/\$RE/};

    # not '$RECYCLE.BIN'
    if [ "$i" == "$name" ]; then

      name=${i/System /};

      # not 'System Volume Information'
      if [ "$i" == "$name" ]; then

        # if there is a "$i".md5
        if [ -e "$i"/"$i".md5 ]; then

          # convert all text files under the directory
          echo -e "\n$i:";	# show the progress

          # replace md5sum for the txt files in "$i".md5
	  cd "$i";
          grep ".txt" "$i".md5 | while read line; do
            oldmd5=$(echo "$line" | head -n1 | cut -d " " -f1);
            f=${line#$oldmd5 \*};

            # no file, then remove the line from "$i".md5
            [ ! -e "$f" ] && sed -i "/$f/d" "$i".md5 && echo " $f: removed" && continue;

            # replace with new md5 value
            result=$(md5sum "$f");
            newmd5=$(echo "$result" | head -n1 | cut -d " " -f1);
            [ "$oldmd5" != "$newmd5" ] && echo " $f: new md5sum" && sed -i "s/$oldmd5/$newmd5/g" "$i".md5;
          done
          cd ..;

	else
          echo -e "\n$i: NO MD5";	# show the progress
        fi # if there is a "$i".md5

      fi # not 'System Volume Information'

    fi # not $RECYCLE.BIN

  fi # process the given arguments

  shift

done

exit 0
