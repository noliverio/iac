class dns {
  package { "bind"
    ensure => 'present',
  }
  package {"bind-chroot"
    ensure => 'present',
  }

  user {"named"
    ensure => 'present',
    shell  =>  '/bin/false',
  }

  file { "/var/named/chroot/etc/named.conf"
    ensure   => 'present',
    selrange => 's0',
    selrole  => 'object_r',
    seltype  => 'named_conf_t',
    seluser  => 'system_u',
  }
  file { "/var/named/chroot/etc/named.rfc1912.zones"
    ensure => 'present',
    selrange => 's0',
    selrole  => 'object_r',
    seltype  => 'named_conf_t',
    seluser  => 'system_u',
  }
  file { "/var/named/chroot/etc/named.empty"
    ensure => 'present',
  }
  file { "/var/named/chroot/etc/named.localhost"
    ensure => 'present',
  }
  file { "/var/named/chroot/etc/named.loopback"
    ensure => 'present',
  }

  service {'named-chroot'
    ensure => 'running'
  }
}
