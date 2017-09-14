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

require 'getoptlong'

opts = GetoptLong.new(
  [ '--role', '-r', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--r10k', GetoptLong::NO_ARGUMENT ],
  [ '--agent', GetoptLong::NO_ARGUMENT ],
  [ '--agent-env', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--agent-memory', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--master-memory',  GetoptLong::OPTIONAL_ARGUMENT ]
)

arg_master_vm_memory = 1024
arg_agent_vm_memory = 512
arg_puppet_role = '' # blank by default so we do not alway override upon ssh'ing
arg_run_r10k = false
arg_run_agent = false
arg_agent_env = 'production'


opts.each do |opt, arg|
  case opt
    when '--agent-memory'
      if arg != ''
        arg_agent_vm_memory = arg.to_i
      end

    when '--master-memory'
      if arg != ''
        arg_master_vm_memory = arg.to_i
      end

    when '--role'
      if arg != ''
        arg_puppet_role = arg
      end

    when '--r10k'
      arg_run_r10k = true

    when '--agent'
      arg_run_agent = true

    when '--agent-env'
      if arg != ''
        arg_agent_env = arg
      end
  end
end

Vagrant.configure('2') do |config|


  config.vm.define :puppetmaster, autostart: false do |node|
    node.vm.box = 'ubuntu/xenial64'

    node.vm.hostname = 'puppetmaster.puppetdebug.vlan'

    # Use vagrant-auto_network to assign an IP address.
    node.vm.network :private_network, :auto_network => true

    # Use vagrant-hosts to add entries to /etc/hosts for each virtual machine
    # in this file.
    node.vm.provision :hosts

    node.vm.provision :shell, :path => 'provision_puppetmaster.sh'

    node.vm.provider "virtualbox" do |v|
      v.memory = [1024, arg_master_vm_memory].max
      v.cpus = 1
    end
  end

  config.vm.define :puppetagent_ubuntu, autostart: false do |node|
    node.vm.box = 'ubuntu/xenial64'

    node.vm.hostname = 'puppetagent.ubuntu.puppetdebug.vlan'

    node.vm.network :private_network, :auto_network => true
    node.vm.provision :hosts

    node.vm.provision :shell, :path => 'provision_ubuntu_puppetagent.sh'

    node.vm.provider "virtualbox" do |v|
      v.memory = [512, arg_agent_vm_memory].max
      v.cpus = 1
    end
  end

  config.vm.define :puppetagent_centos, autostart: false do |node|
    node.vm.box = 'centos/7'

    node.vm.hostname = 'puppetagent.centos.puppetdebug.vlan'

    node.vm.network :private_network, :auto_network => true
    node.vm.provision :hosts

    node.vm.provision :shell, :path => 'provision_centos_puppetagent.sh'

    node.vm.provider "virtualbox" do |v|
      v.memory = [512, arg_agent_vm_memory].max
      v.cpus = 1
    end
  end

  copy_key_command = "cp %s/.ssh/id_rsa ./id_rsa" % [ENV['HOME']]
  config.trigger.before :up do
    info "Copying ~/.ssh/id_rsa into this directory so the puppetmaster can load it for cloning"
    run copy_key_command
  end

  config.trigger.before :ssh do

    run_remote "echo sandbox_ip=$(ifconfig | grep -Po 'inet (addr:)?(10.20.[0-9.]+)' | sed -r 's/inet (addr:)?//') > /etc/facter/facts.d/sandbox_ip.txt"

    if ["puppetagent_ubuntu", "puppetagent_centos"].include? ARGV[1]

      if arg_puppet_role.length > 0
        info "Setting puppet role to %s" % [arg_puppet_role]
        run_remote "echo \"role=%s\" > /etc/facter/facts.d/role.txt" % [arg_puppet_role]
      end

      if arg_run_agent
        run_remote "/opt/puppetlabs/bin/puppet agent --environment=%s -t -v " % [arg_agent_env]
      end
    end

    if ARGV[1] == "puppetmaster"
      if arg_run_r10k
        info "Running r10k!"
        run_remote "r10k deploy environment -vp"
      end
    end
  end

end
