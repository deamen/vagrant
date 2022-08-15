variables {  
  //
  // common variables
  //
  headless               = true
  boot_wait              = "10s"
  cpus                   = 4
  memory                 = 2048
  disk_size = 2048000
  ssh_timeout            = "20m"
  tpl_directory  = "tpls"
  root_shutdown_command  = "/sbin/shutdown -hP now"
  qemu_binary            = ""
  
 
  //
  // Vagrant specific variables
  //

  vagrant_shutdown_command = "echo vagrant | sudo -S /sbin/shutdown -hP now"
  builder_username     = "vagrant"
}
