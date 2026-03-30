#!/bin/bash
[ "$SENDER" != "mouse.clicked" ] && exit 0
VOL=$(sketchybar --query volume.slider | python3 -c "import sys,json;print(int(json.load(sys.stdin)['slider']['percentage']))")
osascript -e "set volume output volume ${VOL:-50}"
