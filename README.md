# Requirements:
1. VMware® Workstation 16 Pro >= 16.2.0 build-18760230
2. Vagrant >= 2.2.18, version restriction applied in Vagrantfile
3. [Vagrant VMware Utility](https://www.vagrantup.com/docs/providers/vmware/vagrant-vmware-utility) >= 1.0.21
4. Vagrant plugins, version restrictions applied in cfg.d/nodes.cfg:
    - vagrant-vmware-desktop: VMware provider
    - [vagrant-winnfsd](https://github.com/winnfsd/vagrant-winnfsd): NFS synced folder
        - To-do: Firewall rules are required for winnfsd, need to find the minimum excetpions.

 

```
netsh advfirewall firewall add rule name="VagrantWinNFSd-1.4.0" dir="in" action=allow protocol=any program="path\to\vagrant\.vagrant\plugins\gems\2.7.4\gems\vagrant-winnfsd-1.4.0\bin\winnfsd.exe" profile=any
netsh advfirewall firewall add rule name="VagrantWinNFSd-1.4.0" dir="out" action=allow protocol=any program="path\to\Prj\vagrant\.vagrant\plugins\gems\2.7.4\gems\vagrant-winnfsd-1.4.0\bin\winnfsd.exe" profile=any
```

# Infomation:
1. The default VMWare virtual network:
    - VMnet0: Bridged
    - VMnet1: Host-only, 192.168.117.0/24
    - VMnet8: NAT, 192.168.140.0/24