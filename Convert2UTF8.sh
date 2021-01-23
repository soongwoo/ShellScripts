#!/bin/bash
#
# Convert to UTF-8 if it's a '.txt' file.
# - '^\xEF\xBB\xBF': UTF-8 with BOM
# - '^\xFE\xFF': UTF-16 BE
# - '^\xFF\xFE': UTF-16 LE
#

OPTIONS="[-debug=0]"
USAGE="Usage: $0 $OPTIONS (dir_i|file_i)"

# check # of arguments
[ "$#" -eq 0 ] && echo "$USAGE" && exit 1;

# initialize the global variables
debug=0

# function convert2utf8
# - 1st argument: text file name
convert2utf8()
{
  f="$1"

  # UTF-8 with BOM
  result=$(sed -n '1s/^\xEF\xBB\xBF//' "$f");
  [ -n "$result" ] && echo " '$f': UTF-8 with BOM" && sed -i '1s/^\xEF\xBB\xBF//' "$f" && return;

  # UTF-16 LE
  result=$(sed -n '1s/^\xFF\xFE//' "$f");
  [ -n "$result" ] && echo " '$f': UTF-16 LE" && sed -i '1s/^\xFF\xFE//' "$f" && return;

  # UTF-16 BE
  result=$(sed -n '1s/^\xFE\xFF//' "$f");
  [ -n "$result" ] && echo " '$f': UTF-16 BE" && sed -i '1s/^\xFE\xFF//' "$f" && return;

  # normal
  echo " '$f'"
}

# process the given arguments
while (( "$#" )); do

  i="$1";	# set a variable

  # option argument
  if [ ${i:0:1} = '-' ]; then

    tmp=${i:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  # it's a directory
  elif [ -d "$i" ]; then

    name=${i/\$RE/};

    # not '$RECYCLE.BIN'
    if [ "$i" == "$name" ]; then

      name=${i/System /};

      # not 'System Volume Information'
      if [ "$i" == "$name" ]; then

        # convert all text files under the directory
        echo -e "\n$i";	# show the progress

	cd "$i";
        find * -type f | while read f; do

          # convert to UTF-8 if it's a text file.
          x=${f%.txt};
          [ "$f" != "$x" ] && convert2utf8 "$f";

        done
	cd ..;

      fi # not 'System Volume Information'

    fi # not $RECYCLE.BIN

  # it's a file
  else

    # convert to UTF-8 if it's a '.txt' file.
    f=${i%.txt};
    [ "$f" != "$i" ] && convert2utf8 "$i";

  fi

  shift

done

exit 0
