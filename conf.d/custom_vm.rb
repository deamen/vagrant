Vagrant.configure("2") do |config|
    ###
    #  vagrant-vmware-desktop: VMware provider
    #  vagrant-winnfsd: NFS synced folder
    ###
    config.vagrant.plugins = ["vagrant-vmware-desktop"]
  
    nodesCfg(config=config,hostname="fedora36-1",boxname="fedora36",
      boxversion="= 202111130946",ip_addr="192.168.117.6",port_forward=nil,ram=2048,cpus=2,v_gui=false)
  
end