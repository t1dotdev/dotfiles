#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
. "$CONFIG_DIR/plugins/icon_map_fn.sh" > /dev/null 2>&1

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

"$CONFIG_DIR/plugins/window_sort" > /tmp/.sb_wpos 2>/dev/null &
aerospace list-windows --all --format '%{workspace}|%{window-id}|%{app-name}' > /tmp/.sb_windows 2>/dev/null &
wait

ALL_WINDOWS=$(</tmp/.sb_windows)
POS_DATA=$(</tmp/.sb_wpos)

if [ "$SENDER" = "front_app_switched" ]; then
  PREV_SIG=""
  [ -f /tmp/.sb_windows_sig ] && PREV_SIG=$(</tmp/.sb_windows_sig)
  if [ "$ALL_WINDOWS" = "$PREV_SIG" ]; then
    exit 0
  fi
fi

printf '%s' "$ALL_WINDOWS" > /tmp/.sb_windows_sig

for i in $(seq 1 9); do printf -v "WS_$i" ""; done

if [ -n "$ALL_WINDOWS" ]; then
  SORTED=$(awk -F'|' -v focused="$FOCUSED" '
    NR==FNR { pos[$1]=$2; next }
    {
      ws=$1; wid=$2; app=$3; seq++
      if (ws == focused && wid in pos) x = pos[wid]
      else x = 100000 + seq
      print ws "|" x "|" app
    }
  ' <(echo "$POS_DATA") <(echo "$ALL_WINDOWS") | sort -t'|' -k1,1n -k2,2n)

  while IFS='|' read -r ws _ app; do
    [ -z "$app" ] && continue
    icon_map "$app"
    varname="WS_$ws"
    cur="${!varname}"
    if [ -n "$cur" ]; then
      printf -v "$varname" "%s %s" "$cur" "$icon_result"
    else
      printf -v "$varname" "%s" "$icon_result"
    fi
  done <<< "$SORTED"
fi

ARGS=()

for SID in $(seq 1 9); do
  varname="WS_$SID"
  icons="${!varname}"

  if [ "$SID" = "$FOCUSED" ]; then
    ARGS+=(--set "space.$SID"
      drawing=on
      icon="$SID"
      icon.color=$WHITE
      label="$icons"
      label.color=$WHITE
      background.drawing=on)
  elif [ -n "$icons" ]; then
    ARGS+=(--set "space.$SID"
      drawing=on
      icon="$SID"
      icon.color=0x55ffffff
      label="$icons"
      label.color=0x55ffffff
      background.drawing=off)
  else
    ARGS+=(--set "space.$SID" drawing=off)
  fi
done

sketchybar "${ARGS[@]}"
