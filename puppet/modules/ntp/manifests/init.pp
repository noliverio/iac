class ntp(
  $server => lookup(ntp::server)
){
  package { 'ntp':
    ensure => 'installed',
  }

  file {'/etc/ntp.conf':
    content => epp('ntp/ntp.conf.epp','server'=>$server)
  }

  service { 'ntpd':
    ensure  => 'running',
    enable  => true,
  }
}
