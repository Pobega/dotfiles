---
name: portmaster-submit
description: >-
  Prepares, validates, and packages ports for PortsMaster/PortMaster-New pull
  requests and troubleshoots handheld Linux SDL2/sysfs rumble. Use when
  cloning or updating PortMaster-New, structuring a port directory, running
  build_release.py, or debugging handheld vibration (e.g., TrimUI Brick).
---

# PortMaster Submission & Handheld Rumble Guide

## 1. Sparse Shallow Clone of `PortMaster-New`

`PortMaster-New` is large; avoid cloning full history or unrelated `ports/*`:

```bash
git clone --depth=1 --filter=blob:none --sparse git@github.com:<user>/PortMaster-New.git
cd PortMaster-New
git sparse-checkout set --cone tools
```

When adding or updating `ports/<portname>/`:
- Fetch upstream `main` with `--depth=1` and branch off `FETCH_HEAD` (never commit on `main`).
- Add the port directory to sparse checkout before `git add`:
  ```bash
  git sparse-checkout add ports/<portname>
  ```
- Never stage generated repo artifacts (`images.zip`, `manifest.json`, `ports.json`, `ports_status.json`, `port_stats_raw.json`).
- Never run `gh pr create` or open a PR directly. After pushing the branch to your fork (when approved), provide the direct GitHub compare/open-PR URL (`https://github.com/PortsMaster/PortMaster-New/compare/main...<user>:PortMaster-New:<branch>?expand=1`) so the user can open the PR themselves.

## 2. `PortMaster-New` Layout & `AGENTS.md` Rules

```text
ports/<portname>/
├── port.json
├── README.md
├── screenshot.png   # 640x480 preferred
├── gameinfo.xml
├── cover.png        # root of ports/<portname>/; gameinfo.xml points to ./<portname>/cover.png
├── <Port Name>.sh   # LF line endings, committed chmod 644 (not 755)
└── <portname>/
    ├── licenses/    # flat folder, one license file per component
    ├── gamedata/    # if empty dir must exist in zip, use an empty descriptive file (e.g. <GAME>_CHD_GOES_HERE), NEVER .gitkeep
    └── <port files>
```

- **No `.gitkeep` files** and no empty placeholder directories like `libs.aarch64/` unless actual `.so` files are bundled (never bundle `libSDL2`, `libc`/`libstdc++`, or Mesa/GL drivers).
- **Validate locally** before committing:
  ```bash
  python3 tools/build_release.py --do-check
  ```
  Confirm `Broken: 0` and inspect the listed zip entries.

## 3. Handheld Vibration (TrimUI Brick / NextUI / `gptokeyb2`)

- **TrimUI Brick (`TRIMUI Player1`)**: Input device exposes `EV=2b` (no `EV_FF`), so `SDL_GameControllerHasRumble()` is false and `SDL_GameControllerRumble()` returns `-1`.
- **Sysfs motor control**: Driven via `/sys/class/gpio/gpio227/value` (`0`/`1`) and `/sys/class/motor/voltage` (microvolts; read initial voltage on start, restore on exit, and cap ceiling around `2200000` uV / `2.2V` to avoid harsh buzz).
- **SDL2 fall-through rule**: Never `return` unconditionally after calling `SDL_GameControllerRumble(pads_[player], ...)`. Only return if it returns `0` (and for player `0`, scan other open pads with `SDL_GameControllerHasRumble` in case `gptokeyb2` created a virtual pad at index `0`); otherwise fall through to sysfs, and turn off both SDL rumble and `gpio227/value` when stopping.
