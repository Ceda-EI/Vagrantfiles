#!/usr/bin/env bash

apt-get update
apt-get install -y vagrant-lxc cgroup-tools

# Configure LXC
echo "root:100000:65536" > /etc/subuid
echo "vagrant:100000:65536" >> /etc/subuid

echo "root:100000:65536" > /etc/subgid
echo "vagrant:100000:65536" >> /etc/subgid

mkdir -p /etc/lxc
echo 'lxc.id_map = u 0 100000 65536' >> /etc/lxc/default.conf
echo 'lxc.id_map = g 0 100000 65536' >> /etc/lxc/default.conf

echo "vagrant veth lxcbr0 10" > /etc/lxc/lxc-usernet

mkdir -p /home/vagrant/.config/lxc/
echo "lxc.include = /etc/lxc/default.conf" > /home/vagrant/.config/lxc/default.conf
echo 'lxc.id_map = u 0 100000 65536' >> /home/vagrant/.config/lxc/default.conf
echo 'lxc.id_map = g 0 100000 65536' >> /home/vagrant/.config/lxc/default.conf
chown -R vagrant:vagrant /home/vagrant/.config
chmod a+x /home/vagrant

systemctl restart lxc

mkdir -p /etc/sysctl.d/
echo kernel.unprivileged_userns_clone=1 > /etc/sysctl.d/80-lxc-userns.conf
sysctl --system
