#!/bin/bash
#
# extract audio from the given video files and convert it to mp3.
#
# Revisions:
#  - if output directory is not specified,
#    then use source directory as output directory.
#  - still need to audio file format
#

OPTION="[-debug=0] [-audio=aac]"
USAGE="Usage: $0 $OPTION mediafile1 mediafile2 ... mediafileN"

# initialize variables with default value
debug=1
audio="aac"

# do main task
[ $# -eq 0 ] && echo "$USAGE" && exit 1

count=0
while (( "$#" )); do

  i="$1";	# set a variable

  # option argument
  if [ ${i:0:1} = '-' ]; then
    tmp=${i:1};			# strip off leading '-'
    parameter=${tmp%%=*};	# extract name
    value=${tmp##*=};		# extract value
    eval $parameter=$value;

  # check whether it exists
  elif [ ! -e "$i" ]; then
    echo "'$i' does not exist!";

  # check whether it's file type
  elif [ ! -f "$i" ]; then
    echo "'$i' is not a file!";

  # it's a media file
  else
    echo "Extract audio from '$1' ..."

    # extract audio with ffmpeg
    ffmpeg -i "$i" -vn -acodec copy "${i%.*}"."$audio";

  fi;

  shift;

done;

exit 0;
