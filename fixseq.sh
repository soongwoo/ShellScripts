#!/bin/sh

# Fix seq number of the given files.
# - delimiter='.'
# - seq format='E'NNN where NNN is number with leading zeros
# - seq position: 2nd 

NNN="3"
IDstr="E"
IDlen=1
DELIMITER='.'
NthARG=2
OPTIONS="[-NNN=3] [-IDstr=E] [-IDlen=1] [-DELIMITER=.] [-NthARG=2]"
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

    seq="$IDstr""$zero""$num"; echo "$seq";

  fi

  shift

done
