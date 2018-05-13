#!/bin/sh
updates=$(checkupdates 2>/dev/null | wc -l)
out=""
out="${out}Updates: ${updates} "
echo "${out%?}"
