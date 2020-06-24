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

# If 'vim' doesn't exist, create an alias to vi
command -v vim >/dev/null 2>&1 || { alias vim='vi'; }
