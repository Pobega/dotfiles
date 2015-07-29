#!/bin/sh

# list of explicitly installed packages (through pacman)
pacman -Qqe | grep -v "$(pacman -Qqm)" > pacman.lst

# list of locally installed packages (through AUR/downloaded)
pacman -Qqm > aur.lst

