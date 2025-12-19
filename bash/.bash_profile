# .bash_profile

# Do this first since `command` won't work after 'vim' alias is setup
export EDITOR=vim
export GIT_EDITOR=vim
# If 'vim' doesn't exist, use vi
command -v vim >/dev/null 2>&1 || { export EDITOR=vi; }
command -v vim >/dev/null 2>&1 || { export GIT_EDITOR=vi; }

[[ -f ~/.bash_shell ]] && . ~/.bash_shell
[[ -f ~/.bash_path ]] && . ~/.bash_path
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -f ~/.bash_local ]] && . ~/.bash_local
[[ -f ~/.bash_work ]] && . ~/.bash_work

# User specific environment and startup programs

export XDG_CONFIG_HOME="$HOME/.config"

export BROWSER=firefox

# rustup
[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env

# For using Podman as Docker inside Toolbx
export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"

# Suppress Podman error messages
# A migration is apparently coming with Podman 5.8, so we can safely ignore this.
export SUPPRESS_BOLTDB_WARNING=1

# Setup NPM for global package installs if it exists
mkdir -p ~/.npm-global
if type "npm" &> /dev/null; then
    npm config set prefix '~/.npm-global'
    export PATH="$HOME/.npm-global/bin:$PATH"
fi
