#!/bin/sh
# updates=$(checkupdates 2>/dev/null | wc -l)
updates=$(yaourt --stats | awk '/Packages out of date: / {print $5}' 2> /dev/null)
out="Updates: ${updates}"
echo "${out}"

