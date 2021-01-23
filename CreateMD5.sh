#!/bin/bash
#
# Check all directory's md5 under current working directory.
#

OPTION="[-debug=0]"
USAGE="Usage: $0 [dir1 dir2 ... dirN]"

# initialize variables
debug=0;
wd=$(pwd);

# function: create_dirmd5()
# 1st argument: directory name
create_dirmd5()
{
  dname=$1;		# 1st argument = directory name

  # ready to process $md5
  md5="$dname".md5;
  [ ! -e "$md5" ] && echo " '$md5'" && touch "$md5";
  chmod 644 "$md5";

  # check whether the checksum is in $md5
  OIFS="$IFS"; IFS=$'\n';		# handle spaces in file name
  for f in $(find * -type f); do

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
    tmp=${i:1};			# strip off leading '-'
    parameter=${tmp%%=*};	# extract name
    value=${tmp##*=};		# extract value
    eval $parameter=$value;

  # if it doesn't exist
  elif [ ! -e "$i" ]; then
    echo -e "\n'$i': Unknown file or directory";

  # it's a file
  elif [ ! -d "$i" ]; then
    echo -e "\n'$i': Not a directory";

  # it's a directory
  else

    # strip off '/' from at the end of string
    lc=${i: -1}; [ "$lc" == '/' ] && i=${i::-1};

    # neither '$RECYCLE.BIN' nor 'System Volume Information'
    if [ "$i" != "\$RECYCLE.BIN" -a "$i" != "System Volume Information" ]; then

      # create the "$i" directory md5
      echo -e "\nCreate '$i' md5:"
      cd "$i";
      create_dirmd5 "$i";
      cd "$wd";

    fi;	# neither '$RECYCLE.BIN' nor 'System Volume Information'

  fi;

  shift;

done;

exit 0;
