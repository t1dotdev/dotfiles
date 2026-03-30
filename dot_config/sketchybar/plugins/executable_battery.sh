#!/bin/bash

case "$SENDER" in
"mouse.exited.global" | "front_app_switched")
  sketchybar --set battery popup.drawing=off
  exit 0
  ;;
esac

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ "$PERCENTAGE" = "" ]; then
  sketchybar --set $NAME icon="􀪯" icon.padding_right=10 label.drawing=off label.padding_right=0
  exit 0
fi

case ${PERCENTAGE} in
  9[0-9]|100) ICON="􀛨" ;;
  [6-8][0-9]) ICON="􀺸" ;;
  [3-5][0-9]) ICON="􀺶" ;;
  [1-2][0-9]) ICON="􀛩" ;;
  *)          ICON="􀛪" ;;
esac

if [ "$CHARGING" != "" ]; then
  ICON="􀢋"
fi

sketchybar --set $NAME icon="$ICON" label="${PERCENTAGE}%"
