#!/usr/bin/env bash

# Add community repositories
echo 'https://mirror.leaseweb.com/alpine/v3.8/community' >> /etc/apk/repositories

# Add testing repositories of edge for installing lxd
echo '@testing http://nl.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories

apk update
apk upgrade
apk add lxc bridge lxc-templates cgmanager
apk add lxd@testing
adduser vagrant lxd

# Configure LXC
echo "root:10000:65536" > /etc/subuid
echo "vagrant:10000:65536" >> /etc/subuid

echo "root:10000:65536" > /etc/subgid
echo "vagrant:10000:65536" >> /etc/subgid

# Enable and Start LXD
rc-update add lxd
rc-update add cgmanager
rc-service lxd start

echo '##################################################'
echo '#                                                #'
echo '#       Reload VM using `vagrant reload`         #'
echo '#     To configure LXD run `sudo lxd init`       #'
echo '#                                                #'
echo '##################################################'
