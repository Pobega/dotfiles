#!/bin/sh

if [ "${1}" == "post" ]; then
  udevadm trigger --subsystem-match="usb"
fi
