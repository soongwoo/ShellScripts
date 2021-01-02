#!/bin/bash
#
# Check all directory's md5 under current working directory.
#

OPTION="[-debug=0]"
USAGE="Usage: $0 [dir1 dir2 ... dirN]"

debug=0

create_dirmd5()
{
  dname=$1;		# 1st argument = directory name

  cd "$dname";

  # ready to process $md5
  md5="$dname".md5;
  [ ! -e "$md5" ] && echo " '$md5'" && touch "$md5" && chmod 644 "$md5";

  # check whether the checksum is in $md5
  find * -type f | while read f; do
    # skip if $f is $md5
    [ "$f" == "$md5" ] && continue;

    # is the checksum in $md5?
    result=$(fgrep "$f" "$md5");
    [ "$?" -ne 0 ] && echo " '$f'" && md5sum "$f" >> "$md5";

  done

  cd ..;
}

if [ "$#" -eq 0 ]; then

  for i in *; do

    # skip if it is not a directory
    [ ! -d "$i" ] && continue;

    # skip $RECYCLE.BIN
    name=${i/\$RE/}; [ "$i" != "$name" ] && continue;

    # skip 'System Volume Information'
    name=${i/System /}; [ "$i" != "$name" ] && continue;

    # check the "$i" directory md5
    echo "check '$i' md5:"
    create_dirmd5 "$i";
    echo "";

  done

else

  while (( "$#" )); do

    # skip if it is not a directory
    [ ! -d "$1" ] && continue;

    i=${1%/*};

    # check the "$i" directory md5
    echo "check '$i' md5:"
    create_dirmd5 "$i";
    echo "";

    shift

  done

fi

exit 0
