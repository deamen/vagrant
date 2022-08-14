variables {  
  //
  // common variables
  //
  headless               = true
  boot_wait              = "10s"
  cpus                   = 4
  memory                 = 2048
  disk_size = 2048000
  http_directory         = "http"
  ssh_timeout            = "40m"
  tpl_directory  = "tpls"
  root_shutdown_command  = "/sbin/shutdown -hP now"
  qemu_binary            = ""
  firmware_x86_64        = "/usr/share/OVMF/OVMF_CODE.fd"
  firmware_aarch64       = "/usr/share/AAVMF/AAVMF_CODE.fd"
  
 
  //
  // Vagrant specific variables
  //

  vagrant_shutdown_command = "echo vagrant | sudo -S /sbin/shutdown -hP now"
  builder_username     = "vagrant"
}
