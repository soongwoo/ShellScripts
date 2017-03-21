#!/bin/sh

# List the empty directories of the given directories.

OPTION="[-mode=debug]"
USAGE="Usage: $0 dir1 dir2 ... dirN"

[ $# -lt 1 ] && echo "$USAGE" && exit 1

LANG=C		# handle multiple byte character string length
count=0		# initialize empty directory count
prevlen=0	# initialize previous printout string length

while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  # directory name
  elif [ -d "$1" ]; then

    # calculate printout string length
    dname=$1
    len=${#dname}
    [ $prevlen -gt $len ] && space=$prevlen || space=$len

    if [ "$(ls -A "$dname")" ]; then
      printf "%-*s\r" $space "$dname"
      prevlen=$len	# update previous printout string length
    else
      dname="'$dname'"": Empty"
      printf "  %-*s\n" $space "$dname"
      (( count++ ))
      prevlen=0
    fi

  fi

  shift

done

# print last line
[ $prevlen -ne 0 ] && printf "%-*s\n" $prevlen ""
echo "$count empty directories"

exit $count
