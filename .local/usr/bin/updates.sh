#!/bin/sh
# updates=$(checkupdates 2>/dev/null | wc -l)
yay -Pn > /tmp/updatesyay.tmp
updates=$(awk '{if ($1 = "Get") print 0; else print $updates;}' /tmp/updatesyay.tmp)
out="${updates}"
echo "${out}"

