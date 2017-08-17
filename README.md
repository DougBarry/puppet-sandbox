BlueOwl Puppet Sandbox
======================

For testing puppet deployed infra locally. First. Before it's in production. Because nobody likes waiting on cloud APIs.

# Instructions

### Install System Dependencies
1. Ensure Vagrant is installed: https://www.vagrantup.com/downloads.html
1. Ensure VirtualBox is installed. Assuming you have `brew` installed it's easiest to just do `brew tap caskroom/cask` then `brew cast install virtualbox'.


### Install Vagrant Dependencies
1. `vagrant plugin install vagrant-hosts`
1. `vagrant plugin install vagrant-auto_network`
1. `vagrant plugin install vagrant-triggers`


### First Boot
1. `git clone git@github.com:BlueOwlDev/puppet-sandbox.git`
1. `cd puppet-sandbox`
1. `vagrant up` - this will take a while as the `puppetmaster` and `puppetagent` boot up.
1. open two terminals (ideally via `tmux`)
1. in the first do: `vagrant ssh puppetmaster` and then once connected run `sudo r10k deploy environment -pv`
1. in the second do: `vagrant ssh puppetagent` and then once connected run `sudo /opt/puppetlabs/bin/puppet agent -t -v`
