#!/bin/sh

# Add more files' md5sum in the given md5sum file.
# - file extension is passed as a parameter
# - files exist in current directory

OPTION="[-ext=mkv]"
USAGE="Usage: $0 $OPTION md5sum-file"

# check the number of argument
[ $# -lt 1 ] && echo "$USAGE" && exit 1

# initialize variables
MD5=""
ext="mkv"
CHECKSUM=md5sum

# main function
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  else

    # make sure it is the first md5sum file
    if [ ! -z "$MD5" ]; then
      echo "too many MD5s"
      break
    fi

    # assign it as MD5
    MD5="$1"
    if [ ! -e "$MD5" ]; then
      echo "$MD5: doe not exist"
      break
    fi

    # do the task
    for f in *"$ext"; do
      # grace exit when there is no file.
      [ ! -e "$f" ] && break

      # same file?
      [ "$f" == "$MD5" ] && continue

      result=$(grep "$f" "$MD5")

      # do md5sum when the file is not in the given md5 file
      [ $? -ne 0 ] && echo "$f" && "$CHECKSUM" "$f" >> "$MD5"
    done

  fi

  shift

done
