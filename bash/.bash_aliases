alias grep='grep --color'
alias ls='ls --color=auto'
alias userctl='systemctl --user'

# Show cpu0 temp in Celsius
alias cpu0_temp='echo -n $(echo "scale=1;$(cat /sys/class/thermal/thermal_zone0/temp)/1000" | bc) && echo "°c"'

###### Toolbox ######

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
    "docker"
    "cross"
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

###### Podman ######

# If we're in an environment with podman-remote and without podman,
# alias podman to podman-remote (toolbox use case)
if command -v podman-remote &> /dev/null && ! command -v podman &> /dev/null; then
    alias podman='podman-remote'
fi

# All in one networking toolkit
# https://hub.docker.com/r/nicolaka/netshoot
# Try --network=host or --privileged
function netshoot()
{
  podman run --rm $@ -it nicolaka/netshoot
}

# Benchmark LLaMA models using llama-bench in a Podman container
llama-bench() {
  # The first argument is the path to your GGUF
  local MODEL_SOURCE="$1"

  # Remove the first argument from the list so "$@" only contains the rest
  shift

  # Check if the file actually exists before starting Podman
  if [[ ! -f "$MODEL_SOURCE" ]]; then
    echo "Error: File '$MODEL_SOURCE' not found."
    return 1
  fi

  podman run -it --rm \
    --name llama-bench \
    --device=/dev/kfd \
    --device=/dev/dri \
    -v "$(realpath "$MODEL_SOURCE"):/model.gguf:z" \
    --entrypoint /app/llama-bench \
    ghcr.io/ggml-org/llama.cpp:full-vulkan \
    -m /model.gguf -ngl 99 "$@"
}
