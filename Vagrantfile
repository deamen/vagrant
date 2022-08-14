#:-*- mode: ruby -*-
# vi: set ft=ruby :

#Branch=merege-ours

Vagrant.require_version ">= 2.2.18"
VDIR = File.dirname(__FILE__)
DOMAIN="yib.me"
BOXNAME="deamen/fedora36"
BOXVER=">= 1.0.0"
CPUS=4
RAM=2048

# Headless mode, default to yes
# Set to true to enable GUI
V_GUI=false

# Specify a URL for the vagrant box, default to empty
# Which means try vagrant cloud
VBOX_URL=""

load "#{VDIR}/conf.d/lib.rb"

Vagrant.configure("2") do |config|
  ###
  #  vagrant-vmware-desktop: VMware provider
  #  vagrant-winnfsd: NFS synced folder
  ###
  config.vagrant.plugins = ["vagrant-vmware-desktop"]

  nodesCfg(config=config,hostname="podman",boxname="#{BOXNAME}",
    boxversion="#{BOXVER}",ip_addr="192.168.117.1",port_forward=nil,ram=RAM,cpus=CPUS,v_gui=V_GUI)

  nodesCfg(config=config,hostname="fedora36",boxname="#{BOXNAME}",
    boxversion="#{BOXVER}",ip_addr="192.168.117.2",port_forward=nil,ram=RAM,cpus=CPUS,v_gui=V_GUI)

  nodesCfg(config=config,hostname="podman",boxname="#{BOXNAME}",
    boxversion="#{BOXVER}",ip_addr="192.168.117.3",port_forward=nil,ram=RAM,cpus=CPUS,v_gui=V_GUI)

  nodesCfg(config=config,hostname="alma9",boxname="almalinux/9",
    boxversion="= 9.0.20220802",ip_addr="192.168.117.8",port_forward=nil,ram=2048,cpus=2,v_gui=V_GUI)

end

# Load the 'custom' VMs
custom_vm_vagrantfile = "#{VDIR}/conf.d/custom_vm.rb"
load custom_vm_vagrantfile if File.file?(custom_vm_vagrantfile)
