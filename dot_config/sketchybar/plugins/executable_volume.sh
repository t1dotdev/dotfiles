#!/bin/bash

case "$SENDER" in
"mouse.exited.global" | "front_app_switched")
  sketchybar --set volume popup.drawing=off
  exit 0
  ;;
esac

if [ "$SENDER" = "volume_change" ]; then
  VOL="$INFO"
else
  VOL=$(osascript -e 'output volume of (get volume settings)' 2>/dev/null)
fi
VOL="${VOL:-0}"

MUTED=$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)

OUTPUT_DEVICE=""
if command -v SwitchAudioSource &>/dev/null; then
  OUTPUT_DEVICE=$(SwitchAudioSource -c 2>/dev/null)
else
  OUTPUT_DEVICE=$(system_profiler SPAudioDataType 2>/dev/null | \
    awk '/:$/ { gsub(/^[ \t]+|[ \t]*:$/, ""); name=$0 }
         /Default Output Device: Yes/ { print name; exit }')
fi

if echo "$OUTPUT_DEVICE" | grep -qi "airpod"; then
  ICON="􀪷"  # airpodspro
elif [ "$MUTED" = "true" ] || [ "$VOL" -eq 0 ] 2>/dev/null; then
  ICON="􀊣"  # speaker.slash.fill
else
  case $VOL in
    [7-9][0-9]|100) ICON="􀊩" ;;  # speaker.wave.3.fill
    [3-6][0-9])     ICON="􀊧" ;;  # speaker.wave.2.fill
    *)              ICON="􀊥" ;;  # speaker.wave.1.fill
  esac
fi

DEVICE_LABEL="${OUTPUT_DEVICE:-Built-in Output}"
if [ "$MUTED" = "true" ]; then
  VOL_LABEL="Muted"
else
  VOL_LABEL="${VOL}%"
fi

sketchybar --set "$NAME" icon="$ICON" \
  --set volume.device icon="$ICON" label="${DEVICE_LABEL} · ${VOL_LABEL}" \
  --set volume.slider slider.percentage="$VOL"
