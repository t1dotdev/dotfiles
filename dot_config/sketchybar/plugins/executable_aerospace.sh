#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

if [ -z "$SORT_POSITIONS" ] && [ "$SENDER" != "front_app_switched" ] && [ -f /tmp/.sb_prev_focused ]; then
  PREV=$(</tmp/.sb_prev_focused)
  if [ "$PREV" != "$FOCUSED" ]; then
    PREV_HAS_WINDOWS=false
    NEW_HAS_WINDOWS=false
    [ -f "/tmp/.sb_ws_${PREV}_icons" ] && [ -s "/tmp/.sb_ws_${PREV}_icons" ] && PREV_HAS_WINDOWS=true
    [ -f "/tmp/.sb_ws_${FOCUSED}_icons" ] && [ -s "/tmp/.sb_ws_${FOCUSED}_icons" ] && NEW_HAS_WINDOWS=true

    if [ "$PREV_HAS_WINDOWS" = true ] && [ "$NEW_HAS_WINDOWS" = true ]; then
      printf '%s' "$FOCUSED" > /tmp/.sb_prev_focused
      sketchybar \
        --set "space.$PREV" icon.color=0x55ffffff label.color=0x55ffffff background.drawing=off \
        --set "space.$FOCUSED" icon.color=$WHITE label.color=$WHITE background.drawing=on
      exit 0
    fi
  fi
fi

printf '%s' "$FOCUSED" > /tmp/.sb_prev_focused

. "$CONFIG_DIR/plugins/icon_map_fn.sh" > /dev/null 2>&1

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
    if [ "$SORT_POSITIONS" != "1" ] && [ -f "/tmp/.sb_ws_${SID}_icons" ]; then
      cached=$(</tmp/.sb_ws_${SID}_icons)
      cached_count=$(echo "$cached" | wc -w)
      fresh_count=$(echo "$icons" | wc -w)
      if [ "$fresh_count" = "$cached_count" ]; then
        icons="$cached"
      elif [ "$fresh_count" -gt "$cached_count" ] 2>/dev/null; then
        new_icons=""
        for icon in $icons; do
          case " $cached " in
            *" $icon "*) ;;
            *) [ -n "$new_icons" ] && new_icons+=" $icon" || new_icons="$icon" ;;
          esac
        done
        [ -n "$new_icons" ] && icons="$cached $new_icons" || icons="$cached"
      fi
    fi
    printf '%s' "$icons" > "/tmp/.sb_ws_${SID}_icons"
    ARGS+=(--set "space.$SID"
      drawing=on
      icon="$SID"
      icon.color=$WHITE
      label="$icons"
      label.color=$WHITE
      background.drawing=on)
  elif [ -n "$icons" ]; then
    if [ -f "/tmp/.sb_ws_${SID}_icons" ]; then
      cached=$(</tmp/.sb_ws_${SID}_icons)
      cached_count=$(echo "$cached" | wc -w)
      fresh_count=$(echo "$icons" | wc -w)
      if [ "$fresh_count" = "$cached_count" ]; then
        icons="$cached"
      elif [ "$fresh_count" -gt "$cached_count" ] 2>/dev/null; then
        new_icons=""
        for icon in $icons; do
          case " $cached " in
            *" $icon "*) ;;
            *) [ -n "$new_icons" ] && new_icons+=" $icon" || new_icons="$icon" ;;
          esac
        done
        [ -n "$new_icons" ] && icons="$cached $new_icons" || icons="$cached"
      fi
    fi
    printf '%s' "$icons" > "/tmp/.sb_ws_${SID}_icons"
    ARGS+=(--set "space.$SID"
      drawing=on
      icon="$SID"
      icon.color=0x55ffffff
      label="$icons"
      label.color=0x55ffffff
      background.drawing=off)
  else
    rm -f "/tmp/.sb_ws_${SID}_icons"
    ARGS+=(--set "space.$SID" drawing=off)
  fi
done

sketchybar "${ARGS[@]}"
