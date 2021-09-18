#!/bin/bash
#
# List all extensions for the arguments
#

# Initialize the duration
SECONDS=0;

OPTION="[-debug=0] [maxlen=7] (dir_i|file_i)+"
USAGE="Usage: $0 $OPTION "

# check # of arguments
[ "$#" -lt 1 ] && echo "$USAGE" && exit 1;

# initialise the variables
debug=1;		# turn off debug mode
maxext="torrent";	# max length extension string
maxlen=${#maxext};	# max length of extension
extstr=();		# extension string array
extfrq=();		# extension frequency array

# function: add_extension
function add_extension ()
{
  # if its length is greater than the max, then ignore it
  [ ${maxlen} -le ${#1} ] && return;

  # any match with existing extensions?
  # shopt -s nocasematch;	# case insensitive match
  ext="${1,,}";
  for i in ${!extstr[@]}; do
    [ "$ext" == "${extstr[$i]}" ] && : $(( extfrq[i]++ )) && return;
  done

  # add it in $extstr
  [ "$debug" -gt 0 ] && echo -e " $1\t$2";
  extstr+=("$ext");
  extfrq+=(1)
}

# process the arguments
while (( "$#" )); do

  i="$1";

  # option argument
  if [ ${i:0:1} = '-' ]; then
    tmp=${i:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  # if it doesn't exist
  elif [ -L "$i" ]; then
    echo "$1: Skip link directory";

  # if it doesn't exist
  elif [ ! -e "$i" ]; then
    echo "$1: Unknown file or directory";

  # it's an argument
  else

    # neither '$RECYCLE.BIN' nor 'System Volume Information'
    # if [ "$fname" != "\$RECYCLE.BIN" -a "$fname" != "System Volume Information" ]; then

      echo "$i:";		# show the progress

      # it's a directory
      if [ -d "$i" ]; then

	# process its sub-directories and files
        OIFS="$IFS"; IFS=$'\n';		# handle spaces in file name
        for f in $(find "$i"/* -type f 2>&1 | grep -v "Permission denied"); do
          dname=${f%\/*}; 		# get the directory
          fname=${f/"$dname"\//};	# get the file name
	  ext=${fname##*.};
	  [ "$fname" != "$ext" ] && add_extension "$ext" "$dname";
        done

      # it's a file
      else
        dname=${i%\/*}; 		# get the directory
        fname=${i/"$dname"\//};		# get the file name
	ext=${fname##*.};
	[ "$fname" != "$ext" ] && add_extension "$ext" "$dname";
      fi

    # fi # neither '$RECYCLE.BIN' nor 'System Volume Information'

  fi

  shift

done

# list all extensions
echo -e "\n-----------"
for i in ${!extstr[@]}; do
  echo -e "${extstr[i]}\t${extfrq[i]}";
done
echo -e "-----------"

# print out the duration
duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."

exit 0
