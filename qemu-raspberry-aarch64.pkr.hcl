data "sshkey" "aarch64" {
}

source "qemu" "aarch64" {
  headless = "true"
  vm_name = "archlinux-raspberry-aarch64.img"
  cpus = 4
  memory = 4096
  format = "raw"
  disk_size = "2500"
  iso_url = "https://mir.archlinux.fr/iso/latest/archlinux-x86_64.iso"
  iso_checksum = "file:https://mir.archlinux.fr/iso/latest/sha256sums.txt"
  ssh_username = "root"
  ssh_private_key_file = data.sshkey.aarch64.private_key_path
  ssh_wait_timeout = "60m"
  boot_wait = "3s"
  boot_key_interval = "10ms"
  boot_command = [
    "<enter>",
    "<wait120>",
    "echo '${data.sshkey.aarch64.public_key}' > ~/.ssh/authorized_keys",
    "<enter>"
  ]
  shutdown_command = "shutdown -P now"
  output_directory = "dist/aarch64"
}

build {
  sources = ["source.qemu.aarch64"]

  provisioner "ansible" {
    playbook_file = "setup.yml"
    ansible_env_vars = [
      "ANSIBLE_FORCE_COLOR=1"
    ]
    extra_arguments = [
      "-D",
      "--scp-extra-args", "'-O'",
      "-e arch=aarch64"
    ]
  }

  provisioner "file" {
    source = "/mnt/boot/dtbs/broadcom/bcm2837-rpi-3-b.dtb"
    destination = "dist/aarch64/"
    direction = "download"
  }

  provisioner "file" {
    source = "/mnt/boot/Image"
    destination = "dist/aarch64/"
    direction = "download"
  }

  provisioner "file" {
    source = "/mnt/boot/initramfs-linux.img"
    destination = "dist/aarch64/"
    direction = "download"
  }
}
