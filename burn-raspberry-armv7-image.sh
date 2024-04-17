#!/bin/bash -e

if [ "$EUID" -ne 0 ]
then
  echo "Please run as root"
  exit 1
fi

echo '#'
echo '# Format SD'
echo '#'
echo
dd if=dist/armv7/archlinux-raspberry-armv7.img of=/dev/mmcblk0 bs=4M conv=fsync status=progress

echo
echo '#'
echo '# Extend root partition'
echo '#'
parted -s /dev/mmcblk0 resizepart 2 100%

echo
echo '#'
echo '# Check root partition'
echo '#'
echo
e2fsck -f /dev/mmcblk0p2

echo
echo '#'
echo '# Resize root fs'
echo '#'
echo
resize2fs /dev/mmcblk0p2
