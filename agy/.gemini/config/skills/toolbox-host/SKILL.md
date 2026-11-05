---
name: toolbox-host
description: >-
  Routes command execution on immutable Fedora Atomic / Silverblue (`/var/home`)
  hosts through Toolbx or ephemeral Podman containers when CLI tools or compilers
  are missing from the base OS or sandbox. Use when a command fails with
  `command not found` (exit code 127) or requires development toolchains inside
  a container. Don't use for host package layering or Flatpak overrides (use
  atomic-desktop) or persistent systemd container units (use podman-quadlets).
---

# Toolbx & Host Execution Workflow

On Fedora Atomic / Silverblue, the host OS root filesystem is immutable and minimal. Compilers, SDKs, and build utilities typically reside inside Toolbx or Podman containers rather than the base image.

## Workflow

1. **Detect Missing Toolchains (Exit Code 127)**:
   - When a command fails with `command not found` (`exit code 127`):
     - Check available Toolbx containers: `toolbox list`.
     - Route command execution through the development container:
       ```bash
       toolbox run --container <name> <command>
       ```
     - Alternatively, use ephemeral container execution scoped strictly to the project directory:
       ```bash
       podman run --rm -v "$PWD":"$PWD":z -w "$PWD" <image> <command>
       ```
     - **SELinux Guardrail**: Never mount `$HOME` (`/var/home/$USER`), `~/dotfiles`, or `~/.config` with `:Z` or `:z`. Recursive SELinux relabeling overwrites `ssh_home_t` on `~/.ssh` and steals MCS labels from Flatpaks and running Quadlet volumes. Always mount only `"$PWD":"$PWD":z` (shared label) or pass `--security-opt label=disable` for trusted local build toolchains.
2. **Shared Storage Advantage**:
   - `$HOME` (which on Fedora Atomic is `/var/home/$USER`) is shared seamlessly across the host and all Toolbx containers.
   - Code edits, dotfiles, git changes, and build artifacts written inside the container are instantly accessible on the host and in the workspace.
3. **Sandbox Hygiene**:
   - Respect `enableTerminalSandbox: true`: keep file preparation, reading, and tests inside the standard sandbox whenever possible.
   - If a host or Toolbx command cannot run inside the sandbox, either give the user a copy-pasteable one-liner or isolate `BypassSandbox: true` strictly to that single prefix-matchable command.
