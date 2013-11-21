#!/bin/bash

echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="19d2", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="2207", MODE="0666", GROUP="plugdev"' > /etc/udev/rules.d/51-android.rules

udevadm control --reload-rules

mkdir ~/.android
echo '0x2207' > ~/.android/adb_usb.ini

adb kill-server && adb start-server

echo "Now plugin your rockchip device"

