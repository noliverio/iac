class  network_default {
  file { '/etc/resolv.conf' :
    ensure => present,
    source => 'puppet:///modules/primary_dns/named.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}
