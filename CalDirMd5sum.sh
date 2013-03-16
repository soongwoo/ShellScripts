#!/bin/sh

# Calculate a directory's md5sum and put the output in the given file.

OPTION="[-md5=dirmd5sum.md5]"
USAGE="Usage: $0 $OPTION file1 file2 ... fileN"
md5="dirmd5sum.md5"

[ $# -lt 1 ] && echo "$USAGE" && exit 1

while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  # check whether it exists
  elif [ ! -e "$1" ]; then
    echo "$1: no file or directory"

  # check whether it is a directory
  elif [ ! -d "$1" ]; then
    echo "$1: not a directory"

  # process arguments
  else
    [ ! -e "$md5" ] && touch "$md5"
    echo "Calculate '$1' ..."
    dirmd5=$(tar c "$1" | md5sum | grep --only-matching -m 1 '^[0-9a-z]*')
    echo "$dirmd5 *$1" >> "$md5"
  fi

  shift

done
