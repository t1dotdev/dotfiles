#!/bin/bash

# Configuration
CONFIG_DIR="${HOME}/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
NAME="wifi"

# Icons
ICON_ETH=􀴞
ICON_VPN=􀎡
ICON_TETHER=􀉤
ICON_WIFI=􀙇
ICON_AIRPORT_OFF=􀐾
ICON_NONE=􀙈

# Detect VPN state (uncomment real command when ready)
# IS_VPN=$(/usr/local/bin/piactl get connectionstate)
IS_VPN="Disconnected"

# Detect wired
WIRED_IFACE=""
WIRED_IP=""

while read -r line; do
  # match lines like "en8: flags=..."
  if [[ $line =~ ^(en[0-9]+): ]]; then
    iface="${BASH_REMATCH[1]}"
    # check if this iface is up and running
    if ifconfig "$iface" | grep -q "status: active"; then
      # get its first IPv4
      ip=$(ifconfig "$iface" | awk '/inet / {print $2; exit}')
      if [[ -n "$ip" ]]; then
        WIRED_IFACE="$iface"
        WIRED_IP="$ip"
        break
      fi
    fi
  fi
done < <(ifconfig)

# Detect Wi-Fi
CURRENT_WIFI="$(ipconfig getsummary en0 2>/dev/null)"
SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID : .*" | sed 's/^SSID : //' | tail -n1)"
IP_WIFI="$(echo "$CURRENT_WIFI" | grep -o "IPv4 Address: .*" | sed 's/^IPv4 Address: //')"

# Decide icon & labels
if [[ $IS_VPN != "Disconnected" ]]; then
  ICON=$ICON_VPN
  LABEL="VPN"
  LABEL2=""
elif [[ $SSID == "T1’s IPhone" ]]; then
  ICON=$ICON_TETHER
  LABEL="$SSID"
  LABEL2="$IP_WIFI"

elif [[ -n $WIRED_IFACE ]]; then
  ICON=$ICON_ETH
  LABEL="$WIRED_IFACE"
  LABEL2="$WIRED_IP"
elif [[ -n $SSID ]]; then
  ICON=$ICON_WIFI
  LABEL="$SSID"
  LABEL2="$IP_WIFI"
elif echo "$CURRENT_WIFI" | grep -q "AirPort: Off"; then
  ICON=$ICON_AIRPORT_OFF
  LABEL="AirPort Off"
  LABEL2=""
else
  ICON=$ICON_NONE
  LABEL="No Wi-Fi"
  LABEL2=""
fi

render_bar_item() {
  sketchybar --set $NAME \
    icon=$ICON \
    icon.color=$WHITE
}

render_popup() {
  if [ "$SSID" != "" ]; then
    args=(
      --set wifi.ssid label="$SSID"
      --set wifi.ipaddress label="$IP_WIFI"
      click_script="printf $IP_WIFI | pbcopy;sketchybar --set wifi popup.drawing=toggle"
    )
  else
    args=(
      --set wifi.ssid label="Not connected"
      --set wifi.ipaddress label="No IP"
    )
  fi

  sketchybar "${args[@]}" >/dev/null
}

update() {
  render_bar_item
  render_popup
}

popup() {
  sketchybar --set "$NAME" popup.drawing="$1"
}

case "$SENDER" in
"routine" | "forced")
  update
  ;;
"mouse.clicked")
  popup toggle
  ;;
esac
