##################################################################################
# LOCALS
##################################################################################

locals {
  buildtime = formatdate("YYYYMMDDhhmmZZZ", timestamp())
  distro    = "fedora36"

  builder_password = vault("mmz/data/vagrant", "password")
  rootpw           = vault("mmz/data/vagrant", "root_password_sha512")
  vagrantpw        = vault("mmz/data/vagrant", "password_sha512")
  guest_os_type    = "fedora-64"
  netinstall_url   = "https://mirrors.fedoraproject.org/mirrorlist?repo=fedora-36&arch=x86_64"
  iso_url          = "https://download.fedoraproject.org/pub/fedora/linux/releases/36/Server/x86_64/iso/Fedora-Server-netinst-x86_64-36-1.5.iso"
  iso_checksum     = "file:https://fedora.mirror.digitalpacific.com.au/linux/releases/36/Server/x86_64/iso/Fedora-Server-36-1.5-x86_64-CHECKSUM"

}

##################################################################################
# SOURCE
##################################################################################

source "vmware-iso" "fedora36" {
  headless     = "${var.headless}"
  iso_url      = "${local.iso_url}"
  iso_checksum = "${local.iso_checksum}"

  guest_os_type    = "${local.guest_os_type}"
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


##################################################################################
# BUILD
##################################################################################

build {
  sources = ["source.vmware-iso.fedora36"]







  provisioner "shell" {
    inline = [
      "sudo dnf install -y open-vm-tools nfs-utils",
    ]
    only = [
      "vmware-iso.fedora36"
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
      "qemu.fedora36"
    ]
  }

  post-processor "vagrant" {
    compression_level    = "9"
    output = "build/${local.distro}_vmware_desktop_${local.buildtime}.box"
  }
}
