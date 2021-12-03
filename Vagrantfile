# -*- mode: ruby -*-
# vi: set ft=ruby :

# Ensure this Project is for Virtualbox Provider
ENV['VAGRANT_DEFAULT_PROVIDER'] = "virtualbox"

# Ensure the required plugins are globally installed
VAGRANT_PLUGINS = [
  "vagrant-vbguest",
  "vagrant-reload",
]
  VAGRANT_PLUGINS.each do |plugin|
    unless Vagrant.has_plugin?("#{plugin}")
      system("vagrant plugin install #{plugin}")
      exit system('vagrant', *ARGV)
    end
  end

# Start the process  
Vagrant.configure("2") do |config|

  config.ssh.insert_key = false
  config.vbguest.auto_update = true
  config.vm.box_check_update = false

  # create Management (mgmt) node
  config.vm.define "mgmt" do |mgvb|
    mgvb.vm.box = "ubuntu/focal64"
    mgvb.vm.hostname = "mgmt"
    mgvb.vm.network :private_network, ip: "192.168.56.10"
    # Provider Virtualbox
    mgvb.vm.provider "virtualbox" do |vb|
      vb.name = "mgmt"
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.memory = "1024"
      vb.cpus = 1
    end # of vb
    # Shared folders
    if Vagrant::Util::Platform.windows? then
      # Configuration SPECIFIC for Windows 10 hosts
      mgvb.vm.synced_folder "tools", "/home/vagrant/tools",
        owner: "vagrant", group: "vagrant",
        mount_options: ["dmode=775","fmode=755"]
    else
      mgvb.vm.synced_folder "tools", "/home/vagrant/tools",
        mount_options: ["dmode=775", "fmode=755"]
    end # of shared folders
    # Provisioning with reload (reboot)
     mgvb.vm.provision "file", source: "./id_rsa", destination: "/home/vagrant/.ssh/"
     mgvb.vm.provision "file", source: "./id_rsa.pub", destination: "/home/vagrant/.ssh/"
     mgvb.vm.provision :shell, path: "bootstrap-mgmt.sh"
     mgvb.vm.provision :reload
  end # of mgvb
end # of config


