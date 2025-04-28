#!/bin/sh

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

if [ $SELECTED = true ]; then
  sketchybar --set $NAME background.drawing=on \
    background.color=$ACCENT_COLOR \
    label.color=$WHITE \
    icon.color=$WHITE \
    background.corner_radius=5 \
    icon.padding_left=4 \
    icon.padding_right=4

else
  sketchybar --set $NAME background.drawing=off \
    label.color=$WHITE \
    icon.color=$WHITE \
    icon.padding_left=4 \
    icon.padding_right=4

fi
