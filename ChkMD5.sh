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

        i=${1%/*};

        # check the "$i" directory md5
        echo -e "\nCheck '$i' md5:"
	cd "$i";
        create_dirmd5 "$i";
	cd ..;

      fi # not 'System Volume Information'

    fi # not $RECYCLE.BIN

  # it's a file
  else
    echo "\n'$i': not a directory";
  fi

  shift

done

exit 0
