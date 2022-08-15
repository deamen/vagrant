##################################################################################
# LOCALS
##################################################################################

locals {
  buildtime = formatdate("YYYYMMDDhhmmZZZ", timestamp())
  distro    = "almalinux9"

  builder_password = vault("mmz/data/vagrant", "password")
  rootpw           = vault("mmz/data/vagrant", "root_password_sha512")
  vagrantpw        = vault("mmz/data/vagrant", "password_sha512")

  netinstall_url   = "https://mirrors.almalinux.org/mirrorlist/9/baseos"
  iso_url          = "https://repo.almalinux.org/almalinux/9.0/isos/x86_64/AlmaLinux-9.0-x86_64-boot.iso"
  iso_checksum     = "file:https://repo.almalinux.org/almalinux/9.0/isos/x86_64/CHECKSUM"

}

##################################################################################
# SOURCE
##################################################################################

source "vmware-iso" "almalinux9" {
  headless     = "${var.headless}"
  iso_url      = "${local.iso_url}"
  iso_checksum = "${local.iso_checksum}"

  guest_os_type    = "centos-64"
  vm_name          = "${local.distro}-tpl"
  cpus             = "${var.cpus}"
  memory           = "${var.memory}"
  disk_size        = "${var.disk_size}"
  boot_wait        = "${var.boot_wait}"
  boot_command     = ["<up><wait><tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${local.distro}-ks.cfg<enter><wait>"]
  shutdown_command = "echo '${var.builder_username}' | sudo -S shutdown -P now"
  http_content = {
    "/${local.distro}-ks.cfg" = templatefile("${local.distro}-ks.cfg.pkrtpl", local)
  }
  ssh_username = "${var.builder_username}"
  ssh_password = "${local.builder_password}"
  ssh_timeout  = "${var.ssh_timeout}"

}

source "virtualbox-iso" "almalinux9" {
  headless     = "${var.headless}"
  iso_url      = "${local.iso_url}"
  iso_checksum = "${local.iso_checksum}"

  guest_additions_mode = "upload"
  guest_additions_url  = "${var.virtualbox_guest_additions_url}"

  guest_os_type    = "RedHat_64"
  # Avoid conflicts when running multiple builds
  output_directory = "build/${local.distro}/${local.buildtime}"
  # Use buildtime as indentifier
  vm_name          = "${local.distro}-tpl-${local.buildtime}"
  cpus             = "${var.cpus}"
  memory           = "${var.memory}"
  disk_size        = "${var.disk_size}"
  boot_wait        = "${var.boot_wait}"
  boot_command     = ["<up><wait><tab> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${local.distro}-ks.cfg<enter><wait>"]
  shutdown_command = "echo '${var.builder_username}' | sudo -S shutdown -P now"
  http_content = {
    "/${local.distro}-ks.cfg" = templatefile("${local.distro}-ks.cfg.pkrtpl", local)
  }
  ssh_username = "${var.builder_username}"
  ssh_password = "${local.builder_password}"
  ssh_timeout  = "${var.ssh_timeout}"

}

##################################################################################
# BUILD
##################################################################################

build {
  sources = [
    "source.vmware-iso.almalinux9",
    "source.virtualbox-iso.almalinux9"
  ]

  provisioner "shell" {
    inline = [
      "sudo dnf install -y open-vm-tools nfs-utils",
    ]
    only = [
      "vmware-iso.almalinux9"
    ]
  }
  
  # Compile virtualbox geust addtions
  provisioner "shell" {
    inline = [
      "sudo dnf install -y nfs-utils wget perl gcc kernel-devel-$(uname -r) bzip2 tar",
      "sudo mkdir /tmp/virtualbox",
      "sudo mount -o loop /home/vagrant/VBoxGuestAdditions.iso /tmp/virtualbox",
      "sudo sh /tmp/virtualbox/VBoxLinuxAdditions.run",
      "sudo umount /tmp/virtualbox",
      "sudo rmdir /tmp/virtualbox",
      "sudo rm /home/vagrant/*.iso",
      "sudo dnf rm -y perl gcc kernel-devel-$(uname -r)"
    ]
    only = [
      "virtualbox-iso.almalinux9",
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo dnf clean all -y",
      "sudo rm -rf /etc/ssh/ssh_host_*",
      "sudo hostnamectl set-hostname localhost.localdomain",
      "sudo rm -rf /etc/udev/rules.d/70-*",
      "sudo sh -c 'cat /dev/null > /etc/machine-id'",
      "sudo rm -rf /var/log/anaconda",
    ]
  }
  
  # Zero freespace to save bandwidth
  # Use junk.1 to avoid slow delete when space is full
  # Doesn't affect too much on vmware VMDK 
  provisioner "shell" {
    inline = [
      "sudo dd if=/dev/zero of=/junk.1 bs=1M count=10240",
      "sudo dd if=/dev/zero of=/junk bs=1M | true",
      "sudo rm -rf /junk.1",
      "sudo rm -rf /junk",
      "sudo sync"
    ]
    only = [
      "qemu.almalinux9"
    ]
  }

  post-processor "vagrant" {
    compression_level = "9"
    output            = "build/${local.distro}_{{.Provider}}_${local.buildtime}.box"
  }
}
