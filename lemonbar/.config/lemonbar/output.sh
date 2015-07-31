#!/usr/bin/bash

COLOR="%{Fgrey}"

BatteryOne() {
    BATC=$(cat /sys/class/power_supply/BAT0/capacity)
    if [ $BATC -le 7 ]; then
        dunstify -p -r "100" -h int:value:$BATC -u critical "Battery dangerously low"
    fi
    BATS=/sys/class/power_supply/BAT0/status
    test "`cat $BATS`" = "Charging" && echo -n "${COLOR}%{F-}" || echo -n "${COLOR}%{F-}"
    echo " $BATC%"
}

BatteryTwo() {
    BATC=$(cat /sys/class/power_supply/BAT1/capacity)
    BATS=/sys/class/power_supply/BAT1/status
    test "`cat $BATS`" = "Charging" && echo -n "${COLOR}%{F-}" || echo -n "${COLOR}%{F-}"
    echo " $BATC%"
}

Clock() {
    DATE=$(date "+%a %b %d, %T")
    echo -n "$DATE"
}

Volume() {
    VOLUME=$(amixer get Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p'| uniq)
    echo "$VOLUME%"
}

CPULoad() {
        LINE=`ps -eo pcpu |grep -vE '^\s*(0.0|%CPU)' |sed -n '1h;$!H;$g;s/\n/ +/gp'`
            bc <<< $LINE
}

Memory() {
        read t f <<< `grep -E 'Mem(Total|Free)' /proc/meminfo |awk '{print $2}'`
            bc <<< "scale=2; 100 - $f / $t * 100" | cut -d. -f1
}

Network() {
    read lo int1 int2 <<< `ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p'`
    if iwconfig $int1 >/dev/null 2>&1; then
        wifi=$int1
        eth0=$int2
    else
        wifi=$int2
        eth0=$int1
    fi
    ip link show $eth0 | grep 'state UP' >/dev/null && int=$eth0 ||int=$wifi
    if iwconfig $int >/dev/null 2>&1; then
        SSID=$(iwconfig $int | grep ESSID | cut -d":" -f 2 | tr -d '"' | tr -d " ")
        ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "${COLOR}%{F-} $SSID " || echo "${COLOR}%{F-} null "
    else
        ping -c 1 8.8.8.8 >/dev/null 2>&1 && echo "${COLOR}%{F-} eth " || echo "${COLOR}%{F-} null "
    fi
}

CheckWifiState() {
    if [ -f /tmp/pobega_wifi.fifo ]; then
        STATE=$(cat /tmp/pobega_wifi.fifo)
        rm /tmp/pobega_wifi.fifo
    else
        STATE=""
    fi

    case $STATE in
    on)
        notify-send "WiFi connection established!"
        ;;
    off)
        notify-send -u critical -t 10000 "WiFi connection lost..."
        ;;
    esac
}

while true; do
    buf=""
    buf="${buf}  "
    buf="${buf} ${COLOR}%{F-} $(CPULoad)%"
    buf="${buf}  "
    buf="${buf} ${COLOR}%{F-} $(Memory)%"
    buf="${buf}  "
    buf="${buf} ${COLOR}%{F-} $(Volume)"
    buf="${buf}  "
    buf="${buf} $(BatteryOne)"
    buf="${buf}  "
    buf="${buf} $(BatteryTwo)"
    buf="${buf}  "
    buf="${buf} %{r}"
    buf="${buf} $(Network)"
    buf="${buf}  "
    buf="${buf} ${COLOR}%{F-} $(date +'%b %d')"
    buf="${buf}  "
    buf="${buf} ${COLOR}%{F-} $(date +'%l:%M %p')"
    buf="${buf}  "
    echo $buf
    CheckWifiState
    sleep 15;
done
