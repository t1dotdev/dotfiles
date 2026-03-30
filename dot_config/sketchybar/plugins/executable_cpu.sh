#!/bin/bash

USAGE=$(top -l 1 -n 0 | grep "CPU usage" | awk '{printf "%.0f", $3 + $5}')

sketchybar --set "$NAME" label="${USAGE}%"
