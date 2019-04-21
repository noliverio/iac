class reverse_proxy(
  $hostname = $facts['hostname'],
  $destination
){
  package { 'epel':
    name   => 'epel-release',
    ensure => 'present'
  }

  package { 'nginx':
    ensure  => 'present',
    require => Package['epel']
  }

  $config_hash = {
    'hostname'    => $hostname,
    'destination' => $destination,
  }

  file { '/etc/nginx/conf.d/blog.conf':
    ensure  => 'present',
    notify  => Service['nginx'],
    content => epp('reverse_proxy/blog.conf.epp', $config_hash);
  }

  service { 'nginx':
    ensure   => 'running',
    provider => 'systemd',
    enable => true,
  }
}
