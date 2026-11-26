---
name: nextui-pak-dev
description: >-
  Builds, cross-compiles, packages, and deploys NextUI Tool/Emu Paks for
  tg5040 (TrimUI Smart Pro/Brick), tg5050 (TrimUI Smart Pro S/Brick Pro), and
  h700 (Anbernic) using NextUI toolchain containers, Gabagool v2 (Go + CGO
  SDL2), or minui-list/minui-presenter. Use when creating or debugging NextUI
  Paks, cross-compiling Gabagool UIs, or deploying to NextUI handhelds via ADB.
---

# NextUI Pak Development Guide

## 1. Toolchain & Packaging (`tg5040` / `tg5050` / `h700`)

- Cross-compile inside `ghcr.io/loveretro/$(PLATFORM)-toolchain:latest` (`podman run --rm --security-opt label=disable -v $(CURDIR):/workspace:rw`) using `/opt/aarch64-nextui-linux-gnu/bin/aarch64-nextui-linux-gnu-{gcc,ar,strip}`.
- Do **not** use `golang:1.24-bullseye` for NextUI CGO binaries (Debian Bullseye apt repos are EOL/404 and newer glibc symbols risk breaking on-device).
- **`tg5050-toolchain` GLES2 / `libmali` quirk**: The `tg5050` sysroot ships `GLES2/gl2.h` without `GLES3/gl3.h` or `KHR/khrplatform.h`, and exports GLES2 symbols from `libmali.so` rather than the `libGLESv2.so` stub. For GLES CMake builds on `tg5050`, pass `-DUSE_GLES=OFF -DUSE_GLES2=ON`, add `KHR/khrplatform.h` via `-DCMAKE_{C,CXX}_STANDARD_INCLUDE_DIRECTORIES=<path>`, and link `-DCMAKE_SHARED_LINKER_FLAGS=-lmali`.
- Package `Tools/<platform>/<PakName>.pak/` (with `pak.json`, `launch.sh`, `README.md`, `LICENSE`, `bin/<platform>/`) and `dist/<PakName>.pak.zip`.
- Deploy over ADB:
  ```sh
  adb push "dist/Tools/$(PUSH_PLATFORM)/$(PAK_NAME).pak/." "/mnt/SDCARD/Tools/$(PUSH_PLATFORM)/$(PAK_NAME).pak"
  ```

## 2. Gabagool v2 UI (Preferred for Multi-Screen Paks)

- Use `github.com/BrandonKowalski/gabagool/v2@main` (`v2.26+`); `v2.0.0` fails `go.mod` parsing due to an older `UncleJunVIP` module path.
- Keep one long-lived `gaba.Init(gaba.Options{WindowTitle: ..., ShowBackground: true, IsNextUI: true})` window to avoid black flashes between menus.
- Use `UseSmallTitle = true` on `ListOptions` / `OptionListSettings` when titles include long status lines or folder names.
- Use `InitialMultiSelectMode = true` with `SelectAllButton` / `DeselectAllButton` (`list.go`) for checklists, and `ProcessMessage` with `ShowProgressBar`, `ProcessInput: true`, and `CancelButton: constants.VirtualButtonB` for background tasks.
- Cross-compile Gabagool inside `ghcr.io/loveretro/$(PLATFORM)-toolchain:latest`:
  1. Build `SDL2_gfx` `1.0.4` (`SDL2_{framerate,gfxPrimitives,imageFilter,rotozoom}.c`) into a static `libSDL2_gfx.a` (NextUI toolchains/devices include `SDL2`, `SDL2_ttf`, and `SDL2_image`, not `SDL2_gfx`).
  2. Write `SDL2_ttf.pc`, `SDL2_image.pc`, and `SDL2_gfx.pc` into a build `pkgconfig/` dir and prepend it to `PKG_CONFIG_PATH`.
  3. Build with:
     ```sh
     CGO_ENABLED=1 GOOS=linux GOARCH=arm64 \
     CC=/opt/aarch64-nextui-linux-gnu/bin/aarch64-nextui-linux-gnu-gcc \
     CGO_CFLAGS="-I/opt/aarch64-nextui-linux-gnu/aarch64-nextui-linux-gnu/libc/usr/include/SDL2 -I/workspace/build/sdl2_gfx" \
     CGO_LDFLAGS="-L/workspace/build/$(PLATFORM)/sdl2_gfx -lSDL2_gfx -lm" \
     go build -trimpath -ldflags="-s -w"
     ```

## 3. `minui-list` / `minui-presenter` / `show2.elf` Quirks

If using shell-based UI tools instead of Gabagool:
- Always pass `--format json` to `minui-list` (never `--format text`, which can segfault with exit `139` when wrapping past the bottom/top of a list on `h700`).
- Stop background `minui-presenter --timeout -1` processes with `kill -9` (`SIGKILL`); `minui-presenter` ignores `SIGTERM`.
- Always pass `--image=<path>` (e.g. a 1×1 transparent PNG) to `show2.elf --mode=daemon`; omitting `--image` causes `show2.elf` to exit immediately.

## 4. On-Device Runtime & Testing

- `tg5040` lacks `/etc/ssl/certs/ca-certificates.crt`; pass `--insecure` (`-k`) to `curl` when no system CA bundle is readable (matching NextUI's `common/http.c`).
- Record any checks that cannot be automated in the dev environment (on-device UI rendering, gamepad navigation, live network/RetroAchievements flows) in a `testing_checklist.md` artifact.

## 5. Libretro Emu Paks & MinArch Quirks

- **`minarch_sync_reference` valid values**: Only `Auto`, `Screen`, and `Native` are valid in `minarch` (`ma_config.c`). Invalid values (such as `Emulated`) silently fall back to `Auto` (`Screen` on NTSC).
- **Use `Native` on `tg5040` and `h700`**: `SDL_GL_SwapWindow` does not block on vsync on `tg5040` or `h700`, so `Screen` runs unlocked; `minarch_sync_reference = Native` (`GFX_flip_fixed_rate`) is required to cap framerate.
- **Audio does not pace `minarch`**: `SND_batchSamples_fixed_rate` drops excess audio instead of blocking. Threaded libretro cores (e.g. Flycastrophe with `reicast_threaded_rendering = enabled`) need vblank pacing (`reicast_vblank_pacing = enabled`) to keep 30 fps games at 100% real-time speed.
- **Hardware-rendered `Debug HUD`**: MinArch's `Debug HUD` only draws on software-rendered cores (`video_refresh_hw` bypasses `drawDebugHud`). For Flycastrophe on-device FPS/speed checks, temporarily set `export FLYCASTROPHE_PERF=1` in `launch.sh` and inspect `$LOGS_PATH/DC.txt`.
