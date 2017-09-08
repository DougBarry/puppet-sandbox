#!/bin/bash

rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install puppet-agent
yum -y install emacs
yum -y install unzip
yum -y install net-tools # need ifconfig
yum -y install bind-utils # need dig
# yum -y install setroubleshoot-server

/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

echo "server=puppetmaster.puppetdebug.vlan" > /etc/puppetlabs/puppet/puppet.conf
mkdir -p /etc/facter/facts.d/

cat >/etc/rc.local <<EOL
#!/bin/bash
echo "env=production" > /etc/facter/facts.d/env.txt
echo "environment=production" > /etc/facter/facts.d/environment.txt
#echo "role=not_set_by_default" > /etc/facter/facts.d/role.txt
EOL

bash /etc/rc.local
systemctl enable rc-local.service

# make our selinux status match the dcos agent
sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
reboot # to actually reflect the selinux change?
