#!/bin/sh

# Swap aadjacent arguments of the given files
# - delimiter='.'

debug=0
PivotARG=3
DELIMITER='.'
OPTIONS="[-debug=0] [-DELIMITER=.] [-PivotARG=3]"
USAGE="Usage: $0 $OPTIONS file1 file2 ... fileN"

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
    echo ""
    echo "$1: directory"

  # what is it?
  else

    # reserve original filename
    fname="$1"

    # get arguments
    let NextARG=PivotARG+1
    pivotarg=$(echo "$fname" | cut -d $DELIMITER -f $PivotARG)
    nextarg=$(echo "$fname" | cut -d $DELIMITER -f $NextARG)
    [ $debug -eq 1 ] && echo "pivotarg='$pivotarg' nextarg='$nextarg'"

    # make the new filename by swaping date argument and name argument
    headstr=${fname/$pivotarg*/};
    tailstr=${fname/*$nextarg/};
    new_fname="$headstr""$nextarg""$DELIMITER""$pivotarg""$tailstr"
    [ $debug -eq 1 ] && echo "headstr='$headstr' tailstr='$tailstr'"
    [ $debug -eq 2 ] && echo "new_fname='$new_fname'"

    # rename it
    if [ -e "$new_fname" ]; then
      echo "'$new_fname' does exist!"
    else
      echo -e "Rename '$fname' as\n\t'$new_fname'"
      mv "$fname" "$new_fname"
    fi

  fi

  shift

done
