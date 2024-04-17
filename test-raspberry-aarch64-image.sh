#!/bin/bash -e

if [ -f dist/aarch64/archlinux-raspberry-aarch64.img ]
then
  qemu-system-aarch64 \
    -M raspi3b \
    -dtb dist/aarch64/bcm2837-rpi-3-b.dtb \
    -kernel dist/aarch64/Image \
    -initrd dist/aarch64/initramfs-linux.img \
    -append "console=ttyAMA0 root=/dev/mmcblk0p2 rw rootwait" \
    -drive "format=raw,file=dist/aarch64/archlinux-raspberry-aarch64.img" \
    -device usb-net,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::2222-:22 \
    -nographic
else
  echo 'Build the image before testing it'
  echo '-> packer build -force -on-error=ask -only=qemu.aarch64 .'
fi
