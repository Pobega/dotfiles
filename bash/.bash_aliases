alias grep='grep --color'
alias ls='ls --color=auto'

alias vagrant='podman run --rm -it \
        --volume /run/libvirt:/run/libvirt \
        --volume "${HOME}:${HOME}:rslave" \
        --env "HOME=${HOME}" \
        --workdir "$(pwd)" \
        --net host \
        --privileged \
        --security-opt label=disable \
        --entrypoint /usr/bin/vagrant \
        localhost/vagrant-container:latest'

alias runvm='qemu-kvm \
-m 8G \
-smp 8 \
-cpu host \
-vga virtio -display sdl,gl=on \
-usb -device usb-tablet,bus=usb-bus.0 \
-show-cursor \
-net nic,model=virtio,macaddr=52:54:00:12:34:56 \
-net user,hostfwd=tcp::9222-:22 \
-hda'

alias protontricks-flat='flatpak run --command=protontricks com.valvesoftware.Steam --no-runtime'

# Show cpu0 temp in Celsius
alias cpu0_temp='echo -n $(echo "scale=1;$(cat /sys/class/thermal/thermal_zone0/temp)/1000" | bc) && echo "°c"'

# If 'vim' doesn't exist, create an alias to toolbox
command -v vim >/dev/null 2>&1 || { alias vim='toolbox run vim'; }
# If 'tmux' doesn't exist, create an alias to toolbox
command -v tmux >/dev/null 2>&1 || { alias tmux='toolbox run tmux'; }

# All in one networking toolkit
# https://hub.docker.com/r/nicolaka/netshoot
# Try --network=host or --privileged
function netshoot()
{
  podman run --rm $@ -it nicolaka/netshoot
}
