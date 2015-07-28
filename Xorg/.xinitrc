# xset stuff
xset +fp /usr/share/fonts/local
xset fp rehash
xset s off
# Simple X Hotkey Daemon
sxhkd &
# Simple compositing
xcompmgr -r 12.00 -o 0.75 -l -15.0 -t -15.0 -I 0.028 -O 0.03 -D 5.0 -c -C -f -F -n &
# Information panel
~/.config/lemonbar/output.sh | lemonbar -B "#262626" -f icons -f fontawesome -f terminus -g 900+270+10 -p -o 1 &
# Wallpaper
feh --bg-scale ~/wallpaper.png &
# Screen autolock after 10 minutes
xautolock -corners -000 -time 10 -locker ~/bin/pixellock.sh &
# Merge terminal configuration
xrdb -merge ~/.Xresources &
# X301 color profile
xcalib ~/.colorprofile.icc &

# Run window manager
exec bspwm
