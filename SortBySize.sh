#!/bin/sh
#

USAGE="$0 outfile"

# check the arguments
[ $# -ne 1 ] && echo "Usage: $USAGE" && exit 1
outfile="$1"

du -k | sort -nr | awk '
     BEGIN {
        split("KB,MB,GB,TB", Units, ",");
     }
     {
        u = 1;
        while ($1 >= 1024) {
           $1 = $1 / 1024;
           u += 1
        }
        $1 = sprintf("%.2f %s", $1, Units[u]);
        print $0;
     }
    ' > "$outfile"