#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

if [ -z "$SORT_POSITIONS" ] && [ "$SENDER" != "front_app_switched" ] && [ -f /tmp/.sb_prev_focused ]; then
  PREV=$(</tmp/.sb_prev_focused)
  if [ "$PREV" != "$FOCUSED" ]; then
    printf '%s' "$FOCUSED" > /tmp/.sb_prev_focused

    PREV_HAS=false; NEW_HAS=false
    [ -f "/tmp/.sb_ws_${PREV}_icons" ] && [ -s "/tmp/.sb_ws_${PREV}_icons" ] && PREV_HAS=true
    [ -f "/tmp/.sb_ws_${FOCUSED}_icons" ] && [ -s "/tmp/.sb_ws_${FOCUSED}_icons" ] && NEW_HAS=true

    ARGS=()
    if [ "$PREV_HAS" = true ]; then
      ARGS+=(--set "space.$PREV" icon.color=0x55ffffff label.color=0x55ffffff background.drawing=off)
    else
      ARGS+=(--set "space.$PREV" drawing=off)
    fi
    if [ "$NEW_HAS" = true ]; then
      ARGS+=(--set "space.$FOCUSED" icon.color=$WHITE label.color=$WHITE background.drawing=on)
    else
      ARGS+=(--set "space.$FOCUSED" drawing=on icon="$FOCUSED" icon.color=$WHITE label="" label.color=$WHITE background.drawing=on)
    fi
    sketchybar "${ARGS[@]}"
    printf '' > /tmp/.sb_ws_debounce
    exit 0
  fi
fi

printf '%s' "$FOCUSED" > /tmp/.sb_prev_focused

# Debounce: skip front_app_switched if workspace change just handled everything
if [ "$SENDER" = "front_app_switched" ] && [ -f /tmp/.sb_ws_debounce ]; then
  rm -f /tmp/.sb_ws_debounce
  exit 0
fi

if [ "$SENDER" = "front_app_switched" ]; then
  FRESH_WINDOWS=$(aerospace list-windows --all --format '%{workspace}|%{window-id}|%{app-name}' 2>/dev/null)
  PREV_SIG=""
  [ -f /tmp/.sb_windows_sig ] && PREV_SIG=$(</tmp/.sb_windows_sig)
  if [ "$FRESH_WINDOWS" = "$PREV_SIG" ]; then
    exit 0
  fi
fi

. "$CONFIG_DIR/plugins/icon_map_fn.sh" > /dev/null 2>&1

if [ -n "$FRESH_WINDOWS" ]; then
  ALL_WINDOWS="$FRESH_WINDOWS"
else
  ALL_WINDOWS=$(aerospace list-windows --all --format '%{workspace}|%{window-id}|%{app-name}' 2>/dev/null)
fi

printf '%s' "$ALL_WINDOWS" > /tmp/.sb_windows_sig

FOCUSED_WID=""
[ -n "$MOVE_DIR" ] && FOCUSED_WID=$(aerospace list-windows --focused --format '%{window-id}' 2>/dev/null)

for i in {1..9}; do printf -v "WIDS_$i" ""; done

while IFS='|' read -r ws wid app; do
  [ -z "$wid" ] && continue
  printf -v "APP_$wid" "%s" "$app"
  varname="WIDS_$ws"
  cur="${!varname}"
  if [ -n "$cur" ]; then
    printf -v "$varname" "%s %s" "$cur" "$wid"
  else
    printf -v "$varname" "%s" "$wid"
  fi
done <<< "$ALL_WINDOWS"

ARGS=()

for SID in {1..9}; do
  varname="WIDS_$SID"
  WS_WIDS="${!varname}"

  if [ -z "$WS_WIDS" ]; then
    rm -f "/tmp/.sb_ws_${SID}_icons" "/tmp/.sb_ws_${SID}_wids"
    if [ "$SID" = "$FOCUSED" ]; then
      ARGS+=(--set "space.$SID"
        drawing=on icon="$SID"
        icon.color=$WHITE label="" label.color=$WHITE
        background.drawing=on)
    else
      ARGS+=(--set "space.$SID" drawing=off)
    fi
    continue
  fi

  TRACKED=""
  [ -f "/tmp/.sb_ws_${SID}_wids" ] && TRACKED=$(</tmp/.sb_ws_${SID}_wids)

  if [ "$SID" = "$FOCUSED" ] && [ -n "$MOVE_DIR" ] && [ -n "$FOCUSED_WID" ] && [ -n "$TRACKED" ]; then
    SAME_SET=true
    for wid in $WS_WIDS; do
      case " $TRACKED " in *" $wid "*) ;; *) SAME_SET=false; break ;; esac
    done

    if [ "$SAME_SET" = true ]; then
      read -ra TARR <<< "$TRACKED"
      FIDX=-1
      for i in "${!TARR[@]}"; do
        [ "${TARR[$i]}" = "$FOCUSED_WID" ] && FIDX=$i && break
      done
      if [ $FIDX -ge 0 ]; then
        case "$MOVE_DIR" in
          left|up)
            if [ $FIDX -gt 0 ]; then
              S=$((FIDX - 1)); TMP="${TARR[$S]}"; TARR[$S]="${TARR[$FIDX]}"; TARR[$FIDX]="$TMP"
            fi ;;
          right|down)
            if [ $FIDX -lt $(( ${#TARR[@]} - 1 )) ]; then
              S=$((FIDX + 1)); TMP="${TARR[$S]}"; TARR[$S]="${TARR[$FIDX]}"; TARR[$FIDX]="$TMP"
            fi ;;
        esac
        TRACKED="${TARR[*]}"
      fi
    fi
  fi

  ORDERED=""
  for wid in $TRACKED; do
    case " $WS_WIDS " in *" $wid "*) ORDERED="${ORDERED:+$ORDERED }$wid" ;; esac
  done
  for wid in $WS_WIDS; do
    case " $ORDERED " in *" $wid "*) ;; *) ORDERED="${ORDERED:+$ORDERED }$wid" ;; esac
  done

  printf '%s' "$ORDERED" > "/tmp/.sb_ws_${SID}_wids"

  icons=""
  for wid in $ORDERED; do
    varname="APP_$wid"
    app="${!varname}"
    [ -z "$app" ] && continue
    icon_map "$app"
    icons="${icons:+$icons }$icon_result"
  done

  printf '%s' "$icons" > "/tmp/.sb_ws_${SID}_icons"

  if [ "$SID" = "$FOCUSED" ]; then
    ARGS+=(--set "space.$SID"
      drawing=on icon="$SID"
      icon.color=$WHITE label="$icons" label.color=$WHITE
      background.drawing=on)
  else
    ARGS+=(--set "space.$SID"
      drawing=on icon="$SID"
      icon.color=0x55ffffff label="$icons" label.color=0x55ffffff
      background.drawing=off)
  fi
done

sketchybar "${ARGS[@]}"

[ "$SENDER" != "front_app_switched" ] && printf '' > /tmp/.sb_ws_debounce
