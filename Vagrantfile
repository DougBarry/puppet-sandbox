# -*- mode: ruby -*-
# vi: set ft=ruby :

box = 'ubuntu/xenial64'
ram = 512

puppet_nodes = [
  
	{:hostname => 'puppetmaster',  
		:ip => '172.16.32.10', 
		:box => box, 
		:fwdhost => 8140, 
		:fwdguest => 8140, 
		:ram => ram},
  
	{:hostname => 'agent1', 
		:ip => '172.16.32.11', 
		:box => box}
]

Vagrant.configure("2") do |config|
  puppet_nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
     	node_config.vm.box = node[:box]
      node_config.vm.network :private_network, ip: node[:ip]

      if node[:fwdhost]
        node_config.vm.network :forwarded_port, guest: node[:fwdguest], host: node[:fwdhost]
      end

      memory = node[:ram] ? node[:ram] : 256;
      node_config.vm.provider :virtualbox do |vb|
        vb.customize [
          'modifyvm', :id,
          '--name', node[:hostname],
          '--memory', memory.to_s
        ]
      end

      node_config.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'manifests'
        puppet.module_path = '~/projects/puppet/modules'
      end
    end
  end
end
