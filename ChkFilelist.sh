#!/bin/sh

# Check the existence of files which are listed in the md5sum checksum file in the given directory.

OPTION="[-debug=0]"
USAGE="Usage: $0 dir1 dir2 ... dirN"

[ $# -lt 1 ] && echo "$USAGE" && exit 1

curdir=$(pwd)

while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  # directory name
  elif [ -d "$1" ]; then

    i=${1%/*};
    cd "$i"

    echo ""
    echo "check '$i' md5:"

    # ready to process $md5
    md5="$i".md5;
    [ ! -e "$md5" ] && echo " '$md5'" && touch "$md5" && chmod 644 "$md5";

    # check whether the checksum is in $md5
    find * -type f | while read f; do
      # skip if $f is $md5
      [ "$f" == "$md5" ] && continue;

      # is the checksum in $md5?
      result=$(fgrep "$f" "$md5");
      [ "$?" -ne 0 ] && echo " '$f'" && md5sum "$f" >> "$md5";

    done

    cd "$curdir"

  fi

  shift

done
