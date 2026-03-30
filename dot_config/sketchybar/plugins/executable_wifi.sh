#!/bin/bash

case "$SENDER" in
"mouse.exited.global" | "front_app_switched")
  sketchybar --set wifi popup.drawing=off
  exit 0
  ;;
esac

IP_WIFI=$(ipconfig getifaddr en0 2>/dev/null)

SSID=""
SSID_RAW=$(networksetup -getairportnetwork en0 2>/dev/null)
if [[ "$SSID_RAW" == "Current Wi-Fi Network: "* ]]; then
  SSID="${SSID_RAW#Current Wi-Fi Network: }"
fi

if [[ -z "$SSID" ]]; then
  SSID=$(ipconfig getsummary en0 2>/dev/null | awk -F' : ' '/^ *SSID/{print $2}')
  [[ "$SSID" == "<redacted>" ]] && SSID=""
fi

if [[ -n "$IP_WIFI" ]]; then
  ICON=􀙇
  SSID="${SSID:-Wi-Fi}"
elif networksetup -getairportpower en0 2>/dev/null | grep -q "Off"; then
  ICON=􀐾
else
  ICON=􀙈
fi

sketchybar --set wifi icon="$ICON"

if [[ -n "$IP_WIFI" ]]; then
  sketchybar \
    --set wifi.ssid label="$SSID" icon=􀙇 \
    --set wifi.ip label="$IP_WIFI" \
      click_script="printf '$IP_WIFI' | pbcopy; sketchybar --set wifi popup.drawing=off"
else
  sketchybar \
    --set wifi.ssid label="Not Connected" icon=􀙈 \
    --set wifi.ip label="No IP"
fi
