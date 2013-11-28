#!/bin/sh

# BPE decryptor could not restore its original filesize
# when its size is more than LONG_MAX(2147483647).
# This script will truncate 410 bytes from the end after running BPE decription.
#
# N.B. MAKE SURE ALL FILES ARE DECRIPTED BEFORE RUNNING THIS SCRIPT!

OPTION=""
USAGE="Usage: $0 $OPTION BPE-decripted-file1 ..."

BPEMAGIC=410
LONGMAX=2147483647
ULONGMAX=4294967295
TRUNC=truncate

# check the number of argument
[ $# -lt 1 ] && echo "$USAGE" && exit 1

# initialize variables
echo "MAKE SURE ALL FILES ARE DECRIPTED BEFORE RUNNING THIS SCRIPT!"
read -p "Press [Enter] to continue ..."

# main function
while (( "$#" )); do

  # option argument
  if [ ${1:0:1} = '-' ]; then
    tmp=${1:1}              # strip off leading '-'
    parameter=${tmp%%=*}    # extract name
    value=${tmp##*=}        # extract value
    eval $parameter=$value

  elif [ -e "$1" ]; then 

    bpe="$1"

    sz=$(stat -c %s "$bpe")	# get file size

    # its file size is greater than LONGMAX
    if [ "$sz" -gt "$LONGMAX" ]; then
      newsz=$[ $sz - $BPEMAGIC ]
      echo "'$bpe': new filesize=$newsz ($sz)"
      truncate -s $newsz "$bpe"
    fi

  fi

  shift

done
