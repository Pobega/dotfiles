# Thinkpad touchpad natural scrolling
xinput --set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Natural Scrolling Enabled' 1
xinput --set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Disable While Typing Enabled' 0

# Disable screen blanking (for playing controller games)
set s off

# better background
xsetroot -solid "#393939"

exec /usr/bin/dwm
