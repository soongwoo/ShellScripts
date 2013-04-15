#!/bin/sh

# Pad a zero in sequel number in its files name.

missing="Missong.txt"
USAGE="Usage: $0 file-list-file"

[ $# -ne 1 ] && echo "$USAGE" && exit 1

nextidx=0

cat "$1" |
  while read fname; do

    [ -z "$fname" ] && continue

    fname=${fname/회*/}
    seq=${fname/*제0/}

    # set start index
    (( $nextidx == 0 )) && nextidx=$seq
    # echo "seq=$seq nextidx=$nextidx"

    # if current seq is greater than the expected
    if (( $seq > $nextidx )); then

      # last index
      lastidx=$(( $seq - 1 ))

      # only one file is missed?
      if (( $lastidx == $nextidx )); then
        echo "'$nextidx'"
      else
        echo "'$nextidx' ~ '$lastidx'"
      fi
    fi

    nextidx=$(( $seq + 1 ))  # expected index

  done

