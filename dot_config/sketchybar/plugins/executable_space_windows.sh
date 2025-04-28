#!/bin/bash

SPACE_SIDS=(1 2 3 4 5)

if [ "$SENDER" = "space_windows_change" ]; then
  for sid in "${SPACE_SIDS[@]}"; do

    space="$sid"
    apps=$(aerospace list-windows --workspace $sid --format '%{app-name}')

    icon_strip=" "
    if [ "${apps}" != "" ]; then
      while read -r app; do
        icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
      done <<<"${apps}"
    else
      icon_strip=" —"
    fi

  done
  sketchybar --set space.$space label="$icon_strip"

fi

# if [ "$SENDER" = "space_windows_change" ]; then
#   for sid in "${SPACE_SIDS[@]}"; do
#
#     space="$sid"
#     apps=$(aerospace list-windows --workspace $sid --format '%{app-name}')
#
#     icon_strip=" "
#     if [ "${apps}" != "" ]; then
#       while read -r app; do
#         icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
#       done <<<"${apps}"
#     else
#       icon_strip=" —"
#     fi
#
#     sketchybar --set space.$space label="$icon_strip"
#   done
#
# fi
