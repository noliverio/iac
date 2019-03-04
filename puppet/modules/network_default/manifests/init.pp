class  network_default {
  file { '/etc/resolv.conf' :
    ensure => present,
    source => 'puppet:///modules/network_default/resolv.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
}
