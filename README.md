BlueOwl Puppet Sandbox
======================

For testing puppet deployed infra locally. First. Before it's in production. Because nobody likes waiting on cloud APIs.


# Instructions

### Install System Dependencies
1. Ensure Vagrant is installed: https://www.vagrantup.com/downloads.html
1. Ensure VirtualBox is installed. Assuming you have `brew` installed it's easiest to just do `brew tap caskroom/cask` then `brew cask install virtualbox`.


### Install Vagrant Dependencies
1. `vagrant plugin install vagrant-hosts`
1. `vagrant plugin install vagrant-auto_network`
1. `vagrant plugin install vagrant-triggers`


### First Boot

NOTE: Anywhere you see `${distro}` valid options are `ubuntu` or `centos`

1. `git clone git@github.com:BlueOwlDev/puppet-sandbox.git`
1. `cd puppet-sandbox`
1. open two (or three) terminals (ideally via `tmux`)
1. In the first run, `vagrant up puppetmaster` - this will take a while if it's the first run.
1. In the second run, `vagrant up puppetagent_${distro}` - your choices are currently `ubuntu` or `centos`
1. in the first do: `vagrant ssh puppetmaster` and then once connected run `sudo r10k deploy environment -pv`
1. in the second do: `vagrant ssh puppetagent_${distro}` and then once connected run `sudo /opt/puppetlabs/bin/puppet agent -t -v` (you'll almost certainly want to also pass the `--environment=TEST` that you're testing)

### Options

#### VM Memory
By default the `puppetmaster` and `puppetagent_${distro}` VMs will have `1024mb` and `512mb` respectively. You can change this using the `--agent-memory` or `--master-memory` option during `up`, like this: `vagrant --agent-memory=768 --master-memory=2048 up`. Please note you cannot use _less_ memory than outlined above _yet_ since some things like `JAVAOPTS` for the puppetserver depend on having a certain amount of memory right now.

#### puppetagent options

You can override the current puppet role by using the `--role` option when `ssh`ing into the `puppetagent_${distro}`, like this: `vagrant --role=somerole ssh puppetagent_${distro}`

You can override the current puppet environment by using the `--agent-env` option when `ssh`ing into the `puppetagent_${distro}`, like this: `vagrant --agent --agent-env=some-env ssh puppetagent_${distro}`


#### puppetagent options

You can force `r10k` to run automatically upon `ssh`ing by using the `--r10k` option, like this: `vagrant --r10k ssh puppetmaster`


#### Example scenario

You're testing a new puppet profile in its own branch and you have that reflected in the `puppet-control` repo's `Puppetfile` with its own branch. The fastest way to test in two terminal windows (or ideally tmux panes) do `vagrant --r10k ssh agentmaster` in one and wait to get connected and then do `vagrant --agent --agent-env=test_authkeys ssh puppetagent_${distro}` in the other (where `test_authkeys` represents the `puppet-control` repo's test branch).


#### Stopping and Starting (again)

To shutdown the machine:
`vagrant halt ${machine_name}` (`puppetmaster`, `puppetagent_centos`, `puppetagent_ubuntu`)

To start the machine back up:

`vagrant up ${machine_name}` (`puppetmaster`, `puppetagent_centos`, `puppetagent_ubuntu`)


#### Starting Fresh

If things get in a bad state simply logout and `halt` and then `rm -rf .vagrant/` from within the `puppet-control` repo.
