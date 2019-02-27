class dns {
  package { "bind"
    ensure => 'present',
  }

  file { "/var/named/chroot/etc/named.conf"
    ensure   => 'present',
    content  => '',
    selrange => 's0',
    selrole  => 'object_r',
    seltype  => 'named_conf_t',
    seluser  => 'system_u',
  }

  file { "/var/named/coffeeandacomputer.local.zone"
    ensure  => 'present',
    content => '',
    notify  => Service['named'],
  }

  service {'named'
    ensure => 'running'
  }
}
