class puppet_master {

    package { 'puppetdb' :
        ensure => 'present',
    }

    service { 'puppetdb' :
        ensure => 'running',
    }

    service { 'puppetserver' :
        ensure =>  'running',
    }
}
