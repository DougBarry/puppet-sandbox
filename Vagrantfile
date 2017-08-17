# -*- mode: ruby -*-
# vi: set ft=ruby :

# This configuration requires Vagrant 1.5 or newer and two plugins:
#
#   vagrant plugin install vagrant-hosts        ~> 2.1.4
#   vagrant plugin install vagrant-auto_network ~> 1.0.0
#   vagrant plugin install vagrant-triggers
#
# See included README.md
Vagrant.require_version ">= 1.5.0"
require 'vagrant-hosts'
require 'vagrant-auto_network'
require 'vagrant-triggers'

Vagrant.configure('2') do |config|

  config.vm.define :puppetmaster do |node|
    node.vm.box = 'ubuntu/xenial64'

    node.vm.hostname = 'puppetmaster.puppetdebug.vlan'

    # Use vagrant-auto_network to assign an IP address.
    node.vm.network :private_network, :auto_network => true

    # Use vagrant-hosts to add entries to /etc/hosts for each virtual machine
    # in this file.
    node.vm.provision :hosts

    node.vm.provision :shell, :path => 'provision_puppetmaster.sh'
  end

  config.vm.define :puppetagent do |node|
    node.vm.box = 'ubuntu/xenial64'

    node.vm.hostname = 'puppetagent.puppetdebug.vlan'

    node.vm.network :private_network, :auto_network => true
    node.vm.provision :hosts

    node.vm.provision :shell, :path => 'provision_puppetagent.sh'
  end

  copy_key_command = "cp %s/.ssh/id_rsa ./id_rsa" % [ENV['HOME']]
  config.trigger.before :up do
    info "Copying ~/.ssh/id_rsa into this directory so the puppetmaster can load it for cloning"
    run copy_key_command
  end

  config.trigger.after :up do
    info "Copying ~/.ssh/id_rsa into this directory so the puppetmaster can load it for cloning"
    run_remote "cp /vagrant/id_rsa /root/.ssh/id_rsa"
  end

end
