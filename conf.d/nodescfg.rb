def nodesCfg(config,hostname,boxname,boxversion,ip_addr,port_forward,ram,cpus,v_gui)

  config.vm.define hostname do |vm_config|
    vm_config.vm.box = boxname
    vm_config.ssh.insert_key = false

    # Go to VBOX_URL to fetch vagrant box if it's not empty
    unless VBOX_URL.empty?
      vm_config.vm.box_url = "#{VBOX_URL}"
    end
    
    vm_config.vm.box_version = boxversion
    vm_config.vm.network "private_network", ip: ip_addr
    vm_config.vm.hostname = hostname + '.' + "#{DOMAIN}"

    ##
    # Synced folders
    ##

    # Vagrant repository folder
    vm_config.vm.synced_folder "#{VDIR}", "/vagrant"

    # Ansible repository folder
    if hostname == 'ansible'
      vm_config.vm.synced_folder "#{VDIR}/../ansible", "/ansible"
      if OS.windows?
        puts "Do nothing".green
      else
        puts "Do nothing".green
      end
    end

    # Container repository folders
    if hostname == 'podman'
      vm_config.vm.synced_folder "#{VDIR}/../ubi", "/ubi"
      vm_config.vm.synced_folder "#{VDIR}/../cifs", "/cifs"
    end


    ##
    # Providers specific configuration
    ##

    # Disable NFS to ensure HGFS is used, otherwise vagrant will try NFS
    # Vmware's HGFS works fine, no reason to use NFS
    config.nfs.functional = false

    vm_config.vm.provider "vmware_desktop" do |v|
      ###
      # https://www.vagrantup.com/docs/providers/vmware/boxes
      ###
      v.allowlist_verified = true

      v.vmx["memsize"] = ram
      v.vmx["numvcpus"] = cpus

      # Force use HGFS
      v.functional_hgfs = true
      v.gui = v_gui
    end
    
    # Port forwrding
    if port_forward
      port_forward.each do |src, dst|
        vm_config.vm.network "forwarded_port", guest: dst, host: src
      end
    end


    ##
    # Provisioning
    ##
    if boxname =~ /fedora36/ || boxname =~ /almalinux9/
      vm_config.vm.provision "shell", path: "files/set_ip_addr.sh", args:["ens32", "#{ip_addr}"]
    end
    if hostname == 'podman'
      vm_config.vm.provision "shell", inline: "sudo dnf -y install podman"
    end
    if hostname == 'ansible'
      vm_config.vm.provision "shell", inline: "sudo dnf -y install ansible"
    end
  end
end

