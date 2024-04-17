#!/bin/bash -e

if [ -f dist/armv7/archlinux-raspberry-armv7.img ]
then
  qemu-system-arm \
    -M raspi2b \
    -dtb dist/armv7/bcm2709-rpi-2-b.dtb \
    -kernel dist/armv7/kernel7.img \
    -initrd dist/armv7/initramfs-linux.img \
    -append "console=ttyAMA0 root=/dev/mmcblk0p2 rw rootwait systemd.default_device_timeout_sec=600s" \
    -drive "format=raw,file=dist/armv7/archlinux-raspberry-armv7.img" \
    -nographic
else
  echo 'Build the image before testing it'
  echo '-> packer build -force -on-error=ask -only=qemu.armv7 .'
fi
