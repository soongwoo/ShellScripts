#!/bin/sh

# This program's integrity is not verified, yet!

OPTION="[-debug=off|on]"
USAGE="Usage: $0 srtfile"

# initialize variables
linenum=0
seq=0
timestr=""

debug="off"
SRT=""
OUTPUT="./output.txt"

# check the arguments
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value
  else
    SRT="$1"
  fi

  shift

done

# check the $SRT argument
[ -z "$SRT" ] && echo "$USAGE" && exit 1

# main function
cat "$SRT" | while read line; do


  nth=$(( ++linenum % 4 )) 

  if [ $nth -eq 0 ]; then
    [ "$debug" == "on" -a ${#line} -ne 1 ] && echo "$line"	# print the line when it has any chars except white chars.
  elif [ $nth -eq 2  -a "$timestr" != "$line" ]; then
    (( seq++ ))
    [ "$timestr" != "" ] && echo ""
    echo "$seq"
    echo "$line"
    timestr="$line"
  elif [ $nth -eq 3 ]; then
    echo "$line"
  fi

done
