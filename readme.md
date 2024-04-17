# Archlinux Raspberry

[![Nightly build](https://github.com/rodolpheche/archlinux-raspberry/actions/workflows/nightly.yml/badge.svg)](https://github.com/rodolpheche/archlinux-raspberry/actions/workflows/nightly.yml)

Archlinux prebuilt images for Raspberry Pi 2/3/4

## Summary

<!-- TOC -->

- [Summary](#summary)
- [Credentials](#credentials)
- [Prebuilt images](#prebuilt-images)
    - [Requirements](#requirements)
    - [Raspberry Pi 2](#raspberry-pi-2)
    - [Raspberry Pi 3/4](#raspberry-pi-34)
- [Custom images](#custom-images)
    - [Requirements](#requirements)
    - [Raspberry Pi 2](#raspberry-pi-2)
        - [Build image](#build-image)
        - [Test image](#test-image)
        - [Burn image](#burn-image)
    - [Raspberry Pi 3/4](#raspberry-pi-34)
        - [Build image](#build-image)
        - [Test image](#test-image)
        - [Burn image](#burn-image)

<!-- /TOC -->

## Credentials

- Root account : `root / root`
- User account : `alarm / alarm`

## Prebuilt images

Burn prebuilt image onto SD card

### Requirements

- parted

### Raspberry Pi 2

```bash
# Download archive
curl -L -O https://github.com/rodolpheche/archlinux-raspberry/releases/latest/download/archlinux-raspberry-armv7.img.tar.gz

# Unarchive image
tar xvf archlinux-raspberry-armv7.img.tar.gz

# Write image on SD
sudo dd if=archlinux-raspberry-armv7.img of=/dev/mmcblk0 bs=4M conv=fsync status=progress

# Extend root partition
sudo parted -s /dev/mmcblk0 resizepart 2 100%

# Check root partition
sudo e2fsck -f /dev/mmcblk0p2

# Resize root fs
sudo resize2fs /dev/mmcblk0p2
```

> SD card is ready to boot on Raspberry Pi 2

### Raspberry Pi 3/4

```bash
# Download archive
curl -L -O https://github.com/rodolpheche/archlinux-raspberry/releases/latest/download/archlinux-raspberry-aarch64.img.tar.gz

# Unarchive image
tar xvf archlinux-raspberry-aarch64.img.tar.gz

# Write image on SD
sudo dd if=archlinux-raspberry-aarch64.img of=/dev/mmcblk0 bs=4M conv=fsync status=progress

# Extend root partition
sudo parted -s /dev/mmcblk0 resizepart 2 100%

# Check root partition
sudo e2fsck -f /dev/mmcblk0p2

# Resize root fs
sudo resize2fs /dev/mmcblk0p2
```

> SD card is ready to boot on Raspberry Pi 3/4

## Custom images

Build image with Packer, QEMU and Ansible

Finally, burn it onto SD card

### Requirements

- packer
- qemu
- ansible
- parted

### Raspberry Pi 2

#### Build image

This is based on the [qemu](https://www.packer.io/plugins/builders/qemu) Packer builder

Build the image with command:

```bash
packer init .
packer build -force -only=qemu.armv7 .
```

> Image should be generated at `dist/armv7/archlinux-armv7.img`

#### Test image

```bash
qemu-system-arm \
  -M raspi2b \
  -dtb dist/armv7/bcm2709-rpi-2-b.dtb \
  -kernel dist/armv7/kernel7.img \
  -initrd dist/armv7/initramfs-linux.img \
  -append "console=ttyAMA0 root=/dev/mmcblk0p2 rw rootwait systemd.default_device_timeout_sec=600s" \
  -drive "format=raw,file=dist/armv7/archlinux-raspberry-armv7.img" \
  -nographic
```

> A prompt may apppear after a while

#### Burn image

```bash
# Format SD
dd if=dist/armv7/archlinux-raspberry-armv7.img of=/dev/mmcblk0 bs=4M conv=fsync status=progress

# Extend root partition
parted -s /dev/mmcblk0 resizepart 2 100%

# Check root partition
e2fsck -f /dev/mmcblk0p2

# Resize root fs
resize2fs /dev/mmcblk0p2
```

> SD card is ready to boot on Raspberry Pi 2

### Raspberry Pi 3/4

#### Build image

This is based on the [qemu](https://www.packer.io/plugins/builders/qemu) Packer builder

Build the image with command:

```bash
packer init .
packer build -force -only=qemu.aarch64 .
```

> Image should be generated at `dist/aarch64/archlinux-raspberry-aarch64.img`

#### Test image

```bash
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
```

> The line `Reached target Graphical Interface.` may appear after a while

You can now connect over SSH :

```bash
ssh alarm@localhost -p 2222
```

#### Burn image

```bash
# Format SD
dd if=dist/aarch64/archlinux-raspberry-aarch64.img of=/dev/mmcblk0 bs=4M conv=fsync status=progress

# Extend root partition
parted -s /dev/mmcblk0 resizepart 2 100%

# Check root partition
e2fsck -f /dev/mmcblk0p2

# Resize root fs
resize2fs /dev/mmcblk0p2
```

> SD card is ready to boot on Raspberry Pi 3/4
