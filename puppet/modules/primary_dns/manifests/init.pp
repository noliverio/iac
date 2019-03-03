class primary_dns {
  package { "bind":
    ensure => 'installed',
  }

  file { "/var/named/chroot/etc/named.conf":
    ensure   => 'present',
    source => 'puppet:///modules/primary_dns/named.conf',
    owner    => 'root',
    group    => 'named',
    mode     => '0640',
    selrange => 's0',
    selrole  => 'object_r',
    seltype  => 'named_conf_t',
    seluser  => 'system_u',
    notify   => Service['named'],
  }

  file { "/var/named/coffeeandacomputer.local.zone":
    ensure   => 'present',
    source => 'puppet:///modules/primary_dns/coffeeandacomputer.local.zone',
    owener   => 'root',
    group    => 'root',
    mode     => '0600',
    selrange => 's0',
    selrole  => 'object_r',
    seltype  => 'named_zone_t',
    seluser  => 'unconfined_u',
    notify   => Service['named'],
  }

  service { 'named':
    ensure => 'running',
  }
}
