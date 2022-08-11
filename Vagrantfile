#:-*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.2.18"
VDIR = File.dirname(__FILE__)
DOMAIN="yib.me"
BOXNAME="fedora35"
BOXVER="= 202111130946"
CPUS=2
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

  nodesCfg(config=config,hostname="fedora35",boxname="#{BOXNAME}",
    boxversion="#{BOXVER}",ip_addr="192.168.117.5",port_forward=nil,ram=RAM,cpus=CPUS,v_gui=V_GUI)

  nodesCfg(config=config,hostname="centos7",boxname="generic/centos7",
    boxversion="= 4.1.4",ip_addr="192.168.117.6",port_forward=nil,ram=2048,cpus=2,v_gui=V_GUI)

end

# Load the 'custom' VMs
custom_vm_vagrantfile = "#{VDIR}/conf.d/custom_vm.rb"
load custom_vm_vagrantfile if File.file?(custom_vm_vagrantfile)