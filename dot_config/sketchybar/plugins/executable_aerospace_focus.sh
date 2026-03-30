#!/bin/sh

FOCUSED="${AEROSPACE_FOCUSED_WORKSPACE:-$FOCUSED_WORKSPACE}"
[ -z "$FOCUSED" ] && FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)
[ -z "$FOCUSED" ] && exit 0

PREV=""
[ -f /tmp/.sb_prev_focused ] && read -r PREV < /tmp/.sb_prev_focused
[ "$PREV" = "$FOCUSED" ] && exit 0

printf '' > /tmp/.sb_ws_debounce
printf '%s' "$FOCUSED" > /tmp/.sb_prev_focused

PREV_HAS=false
NEW_HAS=false
NEW_ICONS=""

[ -n "$PREV" ] && [ -f "/tmp/.sb_ws_${PREV}_icons" ] && [ -s "/tmp/.sb_ws_${PREV}_icons" ] && PREV_HAS=true
[ -f "/tmp/.sb_ws_${FOCUSED}_icons" ] && [ -s "/tmp/.sb_ws_${FOCUSED}_icons" ] && NEW_HAS=true
[ "$NEW_HAS" = true ] && read -r NEW_ICONS < "/tmp/.sb_ws_${FOCUSED}_icons"

if [ -n "$PREV" ] && [ "$PREV_HAS" = true ] && [ "$NEW_HAS" = true ]; then
  exec sketchybar --set "space.$PREV" icon.color=0x55ffffff label.color=0x55ffffff background.drawing=off --set "space.$FOCUSED" drawing=on icon="$FOCUSED" icon.color=0xffffffff label="$NEW_ICONS" label.color=0xffffffff background.drawing=on
fi

if [ -n "$PREV" ] && [ "$PREV_HAS" = true ]; then
  exec sketchybar --set "space.$PREV" icon.color=0x55ffffff label.color=0x55ffffff background.drawing=off --set "space.$FOCUSED" drawing=on icon="$FOCUSED" icon.color=0xffffffff label="" label.color=0xffffffff background.drawing=on
fi

if [ -n "$PREV" ] && [ "$NEW_HAS" = true ]; then
  exec sketchybar --set "space.$PREV" drawing=off --set "space.$FOCUSED" drawing=on icon="$FOCUSED" icon.color=0xffffffff label="$NEW_ICONS" label.color=0xffffffff background.drawing=on
fi

if [ -n "$PREV" ]; then
  exec sketchybar --set "space.$PREV" drawing=off --set "space.$FOCUSED" drawing=on icon="$FOCUSED" icon.color=0xffffffff label="" label.color=0xffffffff background.drawing=on
fi

exec sketchybar --set "space.$FOCUSED" drawing=on icon="$FOCUSED" icon.color=0xffffffff label="" label.color=0xffffffff background.drawing=on
