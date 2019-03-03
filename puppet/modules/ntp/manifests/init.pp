class ntp {
  package { 'ntp':
    ensure => 'installed',
  }

  file {'/etc/ntp.conf':
    source => 'puppet:///modules/ntp/ntp.conf',
  }

  service { 'ntpd':
    ensure =>  'running',
  }
}
