---
name: dotfiles-manager
description: >-
  Maintains personal dotfiles in `~/dotfiles` using GNU Stow and the repository
  `Makefile`. Use when creating, editing, or deploying tracked user
  configuration files (`nvim`, `tmux`, `bash`, `git`, `mutt`, `vim`, `aider`,
  `nanocoder`, `quadlets`, `agy`, `claude`). Don't use for host OS package
  layering or Flatpak permissions (use atomic-desktop).
---

# Dotfiles Management Workflow (GNU Stow)

Personal configuration files are managed declaratively in `~/dotfiles` and linked into `$HOME` via GNU Stow.

## Core Rules

1. **Never Write Directly to `$HOME` for Tracked Configurations**:
   - Creating regular files in `~` or `~/.config` breaks Stow symlinking and creates collision conflicts.
   - Always author or edit configurations directly within `~/dotfiles/<package>/` matching the target `$HOME` hierarchy (e.g., `dotfiles/agy/.gemini/config/...` links to `~/.gemini/config/...`).
2. **Makefile & Tree-Folding Rules**:
   - Check `~/dotfiles/Makefile` whenever introducing a new package:
     - **Universal user configs** (`bash`, `git`, `nvim`, `tmux`, etc.) belong in the default `stow:` target.
     - **Host- or role-specific packages** (such as `quadlets`, which deploys systemd container services) stay in dedicated Makefile targets (`make quadlets`)—do **not** merge them into default `stow:`.
     - **Runtime-shared directories (`--no-folding`)**: Any package targeting a dot-directory where an application also writes runtime state, databases, or auth tokens (`agy` -> `~/.gemini`, `claude` -> `~/.claude`) **must** use `stow --no-folding` so Stow symlinks individual leaf files instead of folding the parent directory into the git working tree.
3. **Deployment**:
   - Restow standard packages (or pass `--no-folding` for `agy` / `claude`):
     ```bash
     stow -v -d ~/dotfiles -t ~ <package>
     stow --no-folding -v -d ~/dotfiles -t ~ agy
     ```
   - If running inside a sandboxed environment where `~` is read-only, advise the user to execute the restow command on the host.
4. **Git Commit Standard**:
   - Format commits using the package scope: `<package>: <imperative description>` (e.g., `agy: add dotfiles-manager skill`, `nvim: update treesitter grammars`).
