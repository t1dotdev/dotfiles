#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

IP_ADDRESS=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)
IS_VPN=$(scutil --nwi | grep -m1 'utun' | awk '{ print $1 }')

if [[ $IS_VPN != "" ]]; then
	COLOR=$CYAN
	ICON=􀙵
	LABEL="VPN"
elif [[ $IP_ADDRESS != "" ]]; then
	COLOR=$BLUE
	ICON=􀙇
	LABEL=$IP_ADDRESS
else
	COLOR=$WHITE
	ICON=􀙈
	LABEL="Not Connected"
fi

sketchybar --set "$NAME" label="$LABEL" icon="$ICON" \
	--subscribe network.logo wifi_change
