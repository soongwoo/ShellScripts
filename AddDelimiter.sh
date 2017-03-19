#!/bin/sh

# Add a delimiter in the given n-th argument of the given filenames
# - delimiter='.'

debug=0
NthARG=3
DELIMITER='.'
NextArgLen=6
OPTIONS="[-debug=0] [-DELIMITER=.] [-NthARG=3] [-NextArgLen=6]"
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
    let NextARG=NthARG+1
    ntharg=$(echo "$fname" | cut -d $DELIMITER -f $NthARG)
    nextarg=$(echo "$fname" | cut -d $DELIMITER -f $NextARG)
    [ $debug -eq 1 ] && echo "ntharg='$ntharg' nextarg='$nextarg'"

    # validate ntharg whether a delimiter can be inserted
    ntharglen=${#ntharg}

    # if nextarg's length is equal to the given length
    if [ ${#nextarg} -eq $NextArgLen ]; then
      echo "'$fname': Valid file name"

    # check whether a delimiter can be inserted
    elif [ $ntharglen -le $NextArgLen ]; then
      echo "'$ntharg': Invalid argument"

    # insert a delimiter
    else

      # calculate delimiter position
      let pos=ntharglen-$NextArgLen

      # get strings before/after delimiter position
      lower=${ntharg:pos}
      upper=${ntharg/$lower/}

      # make the new filename by swaping date argument and name argument
      headstr=${fname/$ntharg*/};
      tailstr=${fname/*$ntharg/};
      new_fname="$headstr""$upper""$DELIMITER""$lower""$tailstr"
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

  fi

  shift

done