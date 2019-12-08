#!/bin/sh

if [ "${1}" == "pre" ]; then
  # Set manually here because `udevadm trigger -s usb`
  # doesn't seem to work as a pre-suspend script.
  udevadm trigger --subsystem-match="usb"
  udevadm settle # block suspend until udev is done
fi
if [ "${1}" == "post" ]; then
  udevadm trigger --subsystem-match="usb"
fi
