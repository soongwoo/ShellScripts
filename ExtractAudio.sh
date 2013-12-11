#!/bin/bash
#
# extract audio from the given video files.
#
# Revisions:
#  - if output directory is not specified,
#    then use source directory as output directory.
#  - still need to audio file format
#

OPTION="[-debug=0] [-outdir=.] [-audio=m4a]"
USAGE="Usage: $0 $OPTION mediafile1 mediafile2 ... mediafileN"

# initialize variables with default value
debug=0
outdir=""
audio="m4a"

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

  if [ "$debug" -ne 0 ]; then
    echo "  srcdir='$srcdir'"
    echo "  filename='$filename'"
    echo "  fname='$fname'"
    echo "  ext='$ext'"
    echo
  fi

  # if output directory is not specified, then use source directory as output directory.
  [ -z "$outdir" ] && outdir="$srcdir"
  [ "$debug" -ne 0 ] && echo " output file: $outdir/$fname.$audio"

  # command: need preset for iPhone4
  ffmpeg -i "$1" -vn -c:a libfdk_aac -b:a 128k "$outdir"/"$fname"."$audio"

  shift;

done

exit 0
