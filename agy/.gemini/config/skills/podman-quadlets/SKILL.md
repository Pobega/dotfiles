---
name: podman-quadlets
description: >-
  Authors and manages rootless Podman systemd Quadlet units (`.container`,
  `.volume`, `.network`, `.kube`) matching Fedora Atomic (`/var/home`) and
  `~/dotfiles/quadlets` conventions. Use when creating, converting, or debugging
  persistent container services or Docker Compose definitions. Don't use for
  one-off dev toolchain commands (use toolbox-host).
---

# Podman Quadlet Management Workflow

On Fedora Atomic, containers run as declarative rootless systemd services managed via Podman Quadlets.

## Directory & Stow Architecture

- **Source path in dotfiles**: `~/dotfiles/quadlets/.config/containers/systemd/`
- **Target deployed path**: `~/.config/containers/systemd/`
- **Stowing**: Deploy via `make -C ~/dotfiles quadlets` (or `stow -d ~/dotfiles -t ~ quadlets`).

## Quadlet File Conventions

When authoring `<name>.container` units, use these standard section directives:

```ini
[Unit]
Description=Service description
After=network-online.target
Wants=network-online.target

[Container]
ContainerName=<name>
Image=docker.io/<org>/<image>:<tag>
# Requires `systemctl --user enable --now podman-auto-update.timer` on host:
AutoUpdate=registry
# Bind to loopback by default unless LAN exposure is explicitly requested:
PublishPort=127.0.0.1:8080:8080
# SELinux bind mounts on dedicated service dirs (never :Z/:z on $HOME itself):
Volume=%h/data/<service>:/data:Z
# Device access (e.g. Intel/AMD VAAPI/DRI) requires container_runtime_t label:
# AddDevice=/dev/dri
# SecurityLabelType=container_runtime_t

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=default.target
```

## Validation & Activation Steps

1. **Dry-Run Syntax Check**:
   ```bash
   /usr/libexec/podman/quadlet --dryrun --user
   ```
   Inspect generated systemd unit text for syntax errors or misparsed keys.
2. **Reload, Start/Restart & Verify Unit** (`daemon-reload` regenerates the transient unit from the Quadlet but does not start it):
   ```bash
   systemctl --user daemon-reload
   systemctl --user restart <name>.service
   systemctl --user status <name>.service
   ```
