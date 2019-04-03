# Installation

### Requirements
Uinput needs to be built as a module (`modprobe uinput` to test), otherwise you may not need `uinput.conf`.

### Descriptions
* `99-uinput-user.rules` - the rules to allow locally logged in users r/w access to uinput peripherals
* `99-steam-controller.rules` - rules for Steam controllers, including Xbox/Playstation/Switch controllers.
* `99-8bitdo.rules` - rules for multiple 8Bitdo controllers
* `uinput.conf` - forces the `uinput` module to be loaded at boot

### File locations
* /etc/udev/rules.d/__99-uinput-user.rules__
* /etc/udev/rules.d/__99-steam-controller.rules__
* /etc/udev/rules.d/__99-8bitdo.rules__
* /etc/modules-load.d/__uinput.conf__
