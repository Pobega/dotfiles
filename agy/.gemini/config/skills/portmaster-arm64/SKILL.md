---
name: portmaster-arm64
description: >-
  Guides reproducible `aarch64-unknown-linux-gnu` cross-compilation, QEMU
  verification, and PortMaster handheld packaging targeting 1 GB RAM ARM64
  devices (ArkOS, muOS, ROCKNIX, KNULLI, AmberELEC). Use when building ARM64
  binaries, auditing glibc/DT_NEEDED portability, or authoring PortMaster
  launchers, `patchscript`, and `port.json` bundles.
---

# PortMaster ARM64 Cross-Compilation & Packaging

## 1. Baseline ABI & Linking Guardrails
- **Target glibc `<= 2.31`** (Debian Bullseye or Ubuntu 20.04 Focal cross-container with `gcc-aarch64-linux-gnu` + `libc6-dev-arm64-cross`) so binaries run across ArkOS, muOS, ROCKNIX, KNULLI, and AmberELEC.
- **Dynamic loading (`dlopen`) over link-time deps**: Prefer `dlopen`/`dlsym` for SDL2, GLESv2/EGL, and FFmpeg so release binaries only require baseline `libc`/`libm`/`libdl`/`libpthread`/`libgcc_s`.
- **Automated ELF checks**: Verify every stripped binary with `readelf -h` (`AArch64`), `readelf -d` (whitelist `DT_NEEDED`), and `readelf --version-info` (`GLIBC <= 2.31`).
- **AOT/JIT icache maintenance**: On AArch64, always flush D-cache to PoU and invalidate I-cache (`dc cvau` -> `dsb ish` -> `ic ivau` -> `dsb ish` -> `isb` via `ctr_el0` line sizes) after writing or patching executable memory.

## 2. QEMU User-Mode Verification
- Install `qemu-user-static` in the cross-builder container and configure `qemu-aarch64-static -L /usr/aarch64-linux-gnu` as the test runner.
- Wrap every emulated binary or smoke test with `timeout --kill-after=5 <seconds>`.

## 3. PortMaster Bundle Conventions
- **Layout**: Top-level `<Name>.sh` + `<portdir>/{bin,cache,gamedata,tools,port.json,README.md}`.
- **Launcher (`<Name>.sh`)**: Source `$controlfolder/control.txt`, `mod_${CFW_NAME}.txt`, and `get_controls`; export `SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"`; honor `DISPLAY_WIDTH`/`DISPLAY_HEIGHT` with sensible 4:3/16:9 aspect fitting; invoke `$controlfolder/utils/patcher.txt` (with direct `bash` fallback) when generated caches are missing or stale; call `pm_platform_helper` and `pm_finish`.
- **On-device `patchscript`**: Validate user binaries before compiling, write output atomically (`mktemp` + `mv -f`), check peak RSS against the device RAM budget, and write a SHA-1 stamp to skip redundant work.
- **Validation**: Lint all scripts with `shellcheck`, validate `port.json` with `python3 -m json.tool`, and explicitly block copyrighted game files (`.exe`, `.bik`, caches) in the zip packager.
