---
name: atomic-desktop
description: >-
  Administers Fedora Atomic / Silverblue / Bazzite immutable desktop systems
  across OSTree deployments, `/etc` drift checks, and Flatpak permissions. Use
  when managing host packages, inspecting OSTree state, configuring Flatpak
  sandbox overrides, or auditing `/etc` on an immutable Fedora host. Don't use
  for running CLI dev compilers (use toolbox-host) or rootless container units
  (use podman-quadlets).
---

# Fedora Atomic Desktop Administration Workflow

Fedora Atomic desktops (Silverblue, Kinoite, Bazzite) feature a read-only `/usr` sysroot composed via OSTree commits. System administration requires adhering to immutability boundaries across containers, Flatpaks, and the host tree.

## 1. Core Immutability Rules

- **Never use `sudo dnf install`**: Traditional package managers do not function directly on OSTree root filesystems.
- **Never attempt write operations in `/usr`**: `/usr` is mounted strictly read-only.
- **Three-Tier Software Placement**:
  1. **CLI & Dev Toolchains**: Place inside Toolbx containers (see `toolbox-host` skill) rather than layering onto the host image.
  2. **Graphical Applications**: Install via Flatpak (`flatpak install flathub <app-id>`).
  3. **Host Layering (`rpm-ostree install`)**: Reserve strictly for hardware drivers, system daemons, virtualization modules, or essential udev rules (e.g., `steam-devices`).

## 2. Host & Deployment Inspection

- **Inspect Active OSTree Deployment**:
  ```bash
  rpm-ostree status
  ```
  Examine the active commit (`*`), pending staged deployments, and layered packages (`LayeredPackages`).
- **Audit Configuration Drift in `/etc`**:
  ```bash
  ostree admin config-diff
  ```
  Compares `/etc` modifications against the default configuration in `/usr/etc` to track local changes or diagnose configuration regressions.
- **Layering Packages**:
  ```bash
  rpm-ostree install <package>
  ```
  Always remind the user that layered packages require a reboot (or `rpm-ostree ex apply-live` where supported) to take effect.

## 3. Flatpak Management & Sandbox Overrides

- **Check Active Permissions**:
  ```bash
  flatpak info --show-permissions <app-id>
  ```
- **Inspect User Overrides**:
  ```bash
  flatpak override --user --show <app-id>
  ```
  Stored locally at `~/.local/share/flatpak/overrides/<app-id>`.
- **Apply Scoped Overrides**:
  - Filesystem access: `flatpak override --user --filesystem=~/data <app-id>`
  - GPU / DRI access: `flatpak override --user --device=dri <app-id>` *(reserve `--device=all` strictly for apps requiring raw USB/controller/webcam access)*
  - Reset overrides: `flatpak override --user --reset <app-id>`
