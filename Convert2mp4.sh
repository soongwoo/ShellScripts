#!/bin/bash
#
# Convert the given files to mp4 with slow preset.
#
# Revisions:
#  - if output directory is not specified, then use source directory as output directory.
#  - still need to specifiy audio/video codec in new mp4 file.
#  - find preset option for iPhone4 or above.
#
#  N.B. Is it really working?

OPTION="[-outdir=.]"
USAGE="Usage: $0 $OPTION mediafile1 mediafile2 ... mediafileN"

# initialize variables with default value
outdir=""

# do main task
[ $# -eq 0 ] && echo "$USAGE" && exit 1

count=0
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value
    shift
    continue
  fi

  echo "Convert '$1' ..."
  filename=${1##*/}         # extract filename
  srcdir=${1/$filename/}    # source directory
  fname=${filename%\.*}     # remove extension
  ext=${filename/$fname/}   # get extension

  # set srcdir if the source are in current directory
  [ -z "$srcdir" ] && srcdir="."

  # take off '/', if it is a last character.
  lastch=$(echo -n "$srcdir" | tail -c -1)
  [ "$lastch" == "/" ] && srcdir=${srcdir/%\//}

  echo "  srcdir='$srcdir'"
  echo "  filename='$filename'"
  echo "  fname='$fname'"
  echo "  ext='$ext'"
  echo

  # if output directory is not specified, then use source directory as output directory.
  [ -z "$outdir" ] && outdir="$srcdir"
  echo " output file: $outdir/$fname.mp4"

  # command: need preset for iPhone4
#  if [ -e "$fname".srt ]; then
#    ffmpeg -i "$1" -vf subtitles="$fname".srt -acodec libfdk_aac -aq 100 -vcodec libx264 -preset slow -crf 22 -threads 0 "$outdir"/"$fname".mp4
#  else
    ffmpeg -i "$1" -acodec libfdk_aac -aq 100 -vcodec libx264 -preset slow -crf 22 -threads 0 "$outdir"/"$fname".mp4
#  fi

  shift;

done

exit 0
