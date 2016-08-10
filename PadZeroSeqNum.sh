#!/bin/sh

# Pad leading zero in seq number of the given files.
# - delimiter='.'
# - seq format='E'NNN where NNN is number with leading zeros
# - seq position: 2nd 

debug=0
NNN="3"
IDstr="E"
IDlen=1
DELIMITER='.'
NthARG=2
OPTIONS="[-debug=0] [-NNN=3] [-IDstr=E] [-IDlen=1] [-DELIMITER=.] [-NthARG=2]"
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

    # get its seq number
    seq=$(echo "$fname" | cut -d $DELIMITER -f $NthARG)

    # validate sequence number grammar
    if [ $IDlen -ne 0 ]; then
      ID=${seq:0:IDlen}
      [ "$ID" != "$IDstr" ] && echo "Illegal sequence number: '$seq'" && continue;
    fi

    # pad leading zero
    zero="";
    num=${seq:1};
    i=${#num};
    while [ $i -lt $NNN ]; do
      zero="0""$zero"
      let i+=1
    done

    new_seq="$IDstr""$zero""$num";
    [ $debug -eq 1 ] && echo "$new_seq";

    # do only if new seq is not same as the old seq
    if [ "$new_seq" != "$seq" ]; then

      # make the new filename
      headstr=${fname/$seq*/};
      tailstr=${fname/*$seq/};
      [ $debug -eq 2 ] && echo "headstr='$headstr' tailstr='$tailstr'"

      new_fname="$headstr""$new_seq""$tailstr"
      [ $debug -eq 2 ] && echo "new_fname='$new_fname'"

      # rename it
      if [ -e "$new_fname" ]; then
        echo "'$new_fname' does exist!"
      else
        echo -e "Rename '$fname' as\n\t'$new_fname'"
        mv "$fname" "$new_fname"
      fi

    else
        echo "'$fname': skipped"
    fi

  fi

  shift

done
