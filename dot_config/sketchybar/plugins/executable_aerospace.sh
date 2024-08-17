#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh
#
#
sketchybar --set $NAME icon=$(aerospace list-workspaces --focused)

# if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
#   sketchybar --set $NAME background.drawing=on
# else
#   sketchybar --set $NAME background.drawing=off
# fi
