# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |vagrant_config|
  vagrant_config.vm.define :node1 do |config|

    # Please verify the sha512 sum of the downloaded box before importing it into vagrant !
    # see https://leap.se/en/docs/platform/details/development#Verify.vagrantbox.download
    # for details

    config.vm.box = "LEAP/wheezy"
    #config.vm.network :private_network, ip: "10.5.5.102"

    # forward leap_web ports
    config.vm.network "forwarded_port", guest: 80,  host:8080
    config.vm.network "forwarded_port", guest: 443, host:4443

    config.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.name = "node1"
    end

    config.vm.provision "puppet" do |puppet|
      puppet.manifests_path = "./vagrant"
      puppet.module_path = "./puppet/modules"
      puppet.manifest_file = "install-platform.pp"
      puppet.options = "--verbose"
    end
    config.vm.provision "shell", path: "vagrant/configure-leap.sh"

    config.ssh.username = "vagrant"

  end
end
