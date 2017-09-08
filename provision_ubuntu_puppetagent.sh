#!/bin/bash

wget https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
dpkg -i puppetlabs-release-pc1-xenial.deb
apt-get update
apt-get install -y puppet-agent unzip
echo "server=puppetmaster.puppetdebug.vlan" > /etc/puppetlabs/puppet/puppet.conf

mkdir -p /etc/facter/facts.d

cat >/etc/rc.local <<EOL
#!/bin/bash
echo "env=production" > /etc/facter/facts.d/env.txt
echo "environment=production" > /etc/facter/facts.d/environment.txt
#echo "role=not_set_by_default" > /etc/facter/facts.d/role.txt
EOL

bash /etc/rc.local
systemctl enable rc-local.service

systemctl start puppet
systemctl enable puppet
