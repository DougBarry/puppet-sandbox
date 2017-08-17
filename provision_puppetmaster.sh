#!/bin/bash

# setup keys
ssh -o StrictHostKeyChecking=no git@github.com
cp /vagrant/id_rsa /root/.ssh/id_rsa

# download and install puppetserver
curl -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
dpkg -i puppetlabs-release-pc1-xenial.deb
apt-get update
apt-get install -y puppetserver

echo '*.puppetdebug.vlan' > /etc/puppetlabs/puppet/autosign.conf
# default puppet server memory is bigger than what we're giving the vm so decrease it
sed -i 's/2g/512m/g' /etc/default/puppetserver


ufw allow 8140
systemctl start puppetserver
systemctl enable puppetserver

# r10k
apt-get install -y r10k

mkdir -p /etc/puppetlabs/r10k

# add our puppet-control repo ro
cat >/etc/puppetlabs/r10k/r10k.yaml <<EOL
:cachedir: /opt/puppetlabs/puppet/cache/r10k
:sources:
  puppet:
    basedir: /etc/puppetlabs/code/environments
    remote: git@github.com:blueowldev/puppet-control.git

git:
  private_key: /root/.ssh/id_rsa
EOL

rm -rf /etc/puppetlabs/code
