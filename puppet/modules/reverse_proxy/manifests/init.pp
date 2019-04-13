class reverse_proxy(
  $hostname = $facts['hostname']
){
  package { 'epel':
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

  $config_hash = {
    'hostname' => $hostname,
  }

  file { '/etc/nginx/conf.d/blog.conf':
    ensure  => 'present',
    notify  => Service['nginx'],
    content => epp('blog.conf.epp', $config_hash);
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

