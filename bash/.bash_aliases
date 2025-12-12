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

# Run these commands in the toolbox when on the host
toolbox_commands=(
    "git"
    "vim"
    "nvim"
    "rg"
    "stow"
    "tmux"
    "copilot"
    "opencode"
)
# Run these commands on the host when in a toolbox
host_commands=(
    "rpm-ostree"
    "podman"
)
if [ -v TOOLBOX_PATH ]; then
    for cmd in "${host_commands[@]}"; do
        alias "$cmd"="flatpak-spawn --host $cmd"
    done
else
    for cmd in "${toolbox_commands[@]}"; do
        alias "$cmd"="toolbox run $cmd"
    done
fi

# All in one networking toolkit
# https://hub.docker.com/r/nicolaka/netshoot
# Try --network=host or --privileged
function netshoot()
{
  podman run --rm $@ -it nicolaka/netshoot
}

alias ollama_init="podman run --pull newer --detach --security-opt label=type:container_runtime_t --replace --device /dev/kfd --device /dev/dri -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama:rocm"
alias ollama_webui="podman run --replace --pull newer -d --network=host -v open-webui:/app/backend/data -e OLLAMA_BASE_URL=http://127.0.0.1:11434 --name open-webui --restart always ghcr.io/open-webui/open-webui:main"
alias ollama="podman exec -it ollama ollama"

# Setup NPM for global package installs if it exists
mkdir -p ~/.npm-global
if type "npm" &> /dev/null; then
    npm config set prefix '~/.npm-global'
    export PATH="$HOME/.npm-global/bin:$PATH"
fi
