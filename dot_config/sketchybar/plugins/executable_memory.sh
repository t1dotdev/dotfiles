#!/bin/bash

TOTAL=$(sysctl -n hw.memsize)
TOTAL_GB=$((TOTAL / 1073741824))
TOTAL_MB=$((TOTAL / 1048576))
USED_PAGES=$(vm_stat | awk '/Pages active|Pages wired/ {gsub(/\./,"",$NF); sum+=$NF} END {print sum}')
USED_MB=$((USED_PAGES * 4096 / 1048576))
AVAIL_MB=$((TOTAL_MB - USED_MB))

if [ $USED_MB -ge 1024 ]; then
  USED_STR="$(awk "BEGIN {printf \"%.1f\", $USED_MB/1024}")G"
else
  USED_STR="${USED_MB}M"
fi

if [ $AVAIL_MB -ge 1024 ]; then
  AVAIL_STR="$(awk "BEGIN {printf \"%.1f\", $AVAIL_MB/1024}")G"
else
  AVAIL_STR="${AVAIL_MB}M"
fi

sketchybar --set "$NAME" label="${USED_STR} / ${TOTAL_GB}G  (${AVAIL_STR} free)"
