class secondary_dns {
  package { "bind":
    ensure => 'installed',
  }

  file { "/etc/named.conf":
    ensure   => 'present',
    source => 'puppet:///modules/secondary_dns/named.conf',
    owner    => 'root',
    group    => 'named',
    mode     => '0640',
    selrange => 's0',
    selrole  => 'object_r',
    seltype  => 'named_conf_t',
    seluser  => 'system_u',
    notify   => Service['named'],
  }

  service { "named":
    ensure => 'running',
  }
}
