#!/usr/bin/bash
function custom {
    "yum install -y puppetserver",
    "systemctl enable puppetserver",
    "systemctl start puppetserver",
    "git clone https://github.com/noliverio/iac.git /home/$2/iac",
    "mv /home/$2/iac/puppet/modules/* /etc/puppetlabs/code/environments/production/modules",
    "mv /home/$2/iac/puppet/manifests/* /etc/puppetlabs/code/environments/production/manifests",
}

