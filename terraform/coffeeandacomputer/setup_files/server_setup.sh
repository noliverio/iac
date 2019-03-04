#!/usr/bin/bash
# This script is intended to be run as sudo on initialization of server.
# Call with the following arguments: hostname, username, (interactive_server/puppet)

function set_hostname {
    chmod 666 /etc/sysconfig/network
    echo "HOSTNAME=$1.coffeeandacomputer.local" >> /etc/sysconfig/network
    chmod 644 /etc/sysconfig/network
    hostnamectl set-hostname $1.coffeeandacomputer.local
}

function interactive_server {
    git clone https://github.com/noliverio/dotfiles.git /home/$2/.dotfiles
    /home/$2/.dotfiles/setup.sh interactive_server
}

function puppet_managed {
    rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    yum install -y puppet-agent
}

function cleanup {
    rm $0
}

function custom {
    if [ $4 == dns ]
    then
        ./dns-server-extras.sh
    elif [ $4 == puppet ]
    then
        ./puppet-server-extras.sh $2
    fi
}




yum update -y
yum install -y git

set_hostname $1

if [ $3 == interactive_server ]
then
    interactive_server
elif [ $3 == puppet_managed ]
then
    puppet_managed
fi

mv /home/$2/setup/resolv.conf /etc/resolv.conf

custom

cleanup
