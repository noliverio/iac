class  network_default {
  include ntp

  package { 'puppet-agent':
    ensure => present,
    provider => 'rpm',
    source => 'https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm',
  }

  package { 'git':
    ensure => present,
  }

  file { '/etc/systemd/system/puppet-agent.service':
    ensure => present,
    source => 'puppet:///modules/network_default/puppet-agent.service', 
    mode   => 0644,
  }

  service { 'puppet-agent':
    ensure =>  running,
  }
}
