#!/bin/bash
if [ "$1" == "low" ]
then
 amixer -q set Master 5%- unmute
elif [ "$1" == "high" ]
then
 amixer -q set Master 5%+ unmute
elif [ "$1" == "mute" ]
then
 amixer -q set Master toggle
else
 echo "Usage volume [low | high | mute]\n"
fi

VOL=$(amixer sget Master | tail -1 | cut -d' ' -f6 | tr -d "[]%")
MUTE=$(amixer sget Master | tail -1 | cut -d' ' -f8 | tr -d "[]%")
# convert VOL to int
let VOL=$VOL/1
if [ $VOL -le 5 ]; then
    TEXT="[                  ]"
elif [ $MUTE == "off" ]; then
    TEXT="[                  ]"
else
    DOTS=$(bc -l <<< "18/(100/$VOL)")
    DOTS=${DOTS%.*}

    TEXT="["
    for i in `seq 1 $DOTS`;
    do
        TEXT+="-"
    done
    let DOTS=18-$DOTS
    for i in `seq 1 $DOTS`;
    do
        TEXT+=" "
    done
    TEXT+="]"
fi

ID=$(cat /home/pobegam/.config/dunst/volume_pid)
if [ $ID -gt "0" ]
then
 dunstify -p -r $ID " Volume: $TEXT" >/home/pobegam/.config/dunst/volume_pid
else
 dunstify -p " Volume: $TEXT" >/home/pobegam/.config/dunst/volume_pid
fi
