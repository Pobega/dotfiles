#!/bin/bash
sleep .5
scrot /tmp/screen.png
convert /tmp/screen.png -scale 20% -scale 500% /tmp/screen.png
[[ -f $1 ]] && convert /tmp/screen.png $1 -gravity center -composite -matte /tmp/screen.png
i3lock -u -i /tmp/screen.png
