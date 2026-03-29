#!/bin/bash

case "$SENDER" in
"mouse.exited.global" | "front_app_switched")
  sketchybar --set wifi popup.drawing=off
  exit 0
  ;;
esac

CURRENT_WIFI="$(ipconfig getsummary en0 2>/dev/null)"
SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID : .*" | sed 's/^SSID : //' | tail -n1)"
IP_WIFI="$(echo "$CURRENT_WIFI" | grep -o "IPv4 Address: .*" | sed 's/^IPv4 Address: //')"

if [[ -n "$SSID" ]]; then
  ICON=􀙇
elif echo "$CURRENT_WIFI" | grep -q "AirPort: Off"; then
  ICON=􀐾
else
  ICON=􀙈
fi

sketchybar --set wifi icon="$ICON"

if [[ -n "$SSID" ]]; then
  sketchybar \
    --set wifi.ssid label="$SSID" icon=􀙇 \
    --set wifi.ip label="$IP_WIFI" \
      click_script="printf '$IP_WIFI' | pbcopy; sketchybar --set wifi popup.drawing=off"
else
  sketchybar \
    --set wifi.ssid label="Not Connected" icon=􀙈 \
    --set wifi.ip label="No IP"
fi
