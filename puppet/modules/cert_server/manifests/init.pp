  package { 'certbot':
    ensure => 'present',
    require => Package['epel']
  }
  package { 'certbot-assist':
    name => 'python2-certbot-nginx',
    ensure => 'present',
    require => Package['epel']
  }


  # The eff recomends running the renew process twice a day, and requests running it at a random minute.
  cron { 'renew_cert':
    command => 'certbot renew',
    hour    => [0,12],
    minute  => [42],
    user    => 'root',
  }
