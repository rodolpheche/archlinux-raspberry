data "sshkey" "armv7" {
}

source "qemu" "armv7" {
  headless = "true"
  vm_name = "archlinux-raspberry-armv7.img"
  cpus = 4
  memory = 4096
  format = "raw"
  disk_size = "3000"
  iso_url = "https://mir.archlinux.fr/iso/latest/archlinux-x86_64.iso"
  iso_checksum = "file:https://mir.archlinux.fr/iso/latest/sha256sums.txt"
  ssh_username = "root"
  ssh_private_key_file = data.sshkey.armv7.private_key_path
  ssh_wait_timeout = "60m"
  boot_wait = "3s"
  boot_key_interval = "10ms"
  boot_command = [
    "<enter>",
    "<wait120>",
    "echo '${data.sshkey.armv7.public_key}' > ~/.ssh/authorized_keys",
    "<enter>"
  ]
  shutdown_command = "shutdown -P now"
  output_directory = "dist/armv7"
}

build {
  sources = ["source.qemu.armv7"]

  provisioner "ansible" {
    playbook_file = "setup.yml"
    ansible_env_vars = [
      "ANSIBLE_FORCE_COLOR=1"
    ]
    extra_arguments = [
      "-D",
      "--scp-extra-args", "'-O'",
      "-e arch=armv7"
    ]
  }

  provisioner "file" {
    source = "/mnt/boot/bcm2709-rpi-2-b.dtb"
    destination = "dist/armv7/"
    direction = "download"
  }

  provisioner "file" {
    source = "/mnt/boot/kernel7.img"
    destination = "dist/armv7/"
    direction = "download"
  }

  provisioner "file" {
    source = "/mnt/boot/initramfs-linux.img"
    destination = "dist/armv7/"
    direction = "download"
  }
}
