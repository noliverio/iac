class ntp {
  package { 'ntp':
    ensure => 'present',
  }

  file {'/etc/ntp.conf':
    source => 'puppet:///modules/ntp/ntp.conf',
  }

  service { 'ntp':
    ensure =>  'running',
  }
}
