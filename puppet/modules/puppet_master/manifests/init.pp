class puppet_master {

    package { 'puppetdb' :
        ensure => 'present',
    }

    file {'/etc/puppetlabs/puppetserver/conf.d/autosign.conf':
      ensure  => 'present',
      source => 'puppet:///modules/puppet_master/files/autosign.conf',
    }

    service { 'puppetdb' :
        ensure => 'running',
    }

    service { 'puppetserver' :
        ensure =>  'running',
        provider => 'systemd',
    }
}
