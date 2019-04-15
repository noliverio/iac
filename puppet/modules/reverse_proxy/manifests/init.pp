class reverse_proxy(
  $hostname = $facts['fqdn'],
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

  package { 'certbot':
    ensure => 'present',
    require => Package['epel']
  }
  package { 'certbot-assist':
    name => 'python2-certbot-nginx',
    ensure => 'present',
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
    ensure => 'running',
  }

  # The eff recomends running the renew process twice a day, and requests running it at a random minute.
  cron { 'renew_cert':
    command => 'certbot renew',
    hour    => [0,12],
    minute  => [42],
    user    => 'root',
  }
}

