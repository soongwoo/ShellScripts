#!/bin/sh

# Pad a zero in sequel number in its files name.

USAGE="Usage: $0 file-list-file"

[ $# -ne 1 ] && echo "$USAGE" && exit 1

cat "$1" |
  while read oldfname; do
    newfname=${oldfname/제/제0}
    echo "rename to '$newfname'"
    mv "$oldfname" "$newfname"
  done

