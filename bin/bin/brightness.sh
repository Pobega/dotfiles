#!/bin/bash

BRIGHTNESS=$(cat /sys/class/backlight/acpi_video0/actual_brightness)

let BRIGHTNESS=$BRIGHTNESS-1
if [ $BRIGHTNESS -lt 0 ]; then
    BRIGHTNESS=0
fi

TEXT="["
for i in `seq 1 $BRIGHTNESS`;
do
    TEXT+="-"
done
let BRIGHTNESS=14-$BRIGHTNESS
for i in `seq 1 $BRIGHTNESS`;
do
    TEXT+=" "
done
TEXT+="]"

ID=$(cat /home/pobegam/.config/dunst/brightness_pid)
if [ $ID -gt "0" ]
then
 dunstify -p -r $ID "Brightness: $TEXT" >/home/pobegam/.config/dunst/brightness_pid
else
 dunstify -p "Brightness: $TEXT" >/home/pobegam/.config/dunst/brightness_pid
fi
