#!/bin/bash

CPU=$(ps -A -o %cpu | awk '{s+=$1} END {printf "%.0f", s}')
CORES=$(sysctl -n hw.ncpu)
USAGE=$((CPU / CORES))

sketchybar --set "$NAME" label="${USAGE}%"
