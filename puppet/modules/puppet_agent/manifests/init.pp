class puppet {
  package { 'puppet' :
    ensure => present,
  }

  service { 'puppet':
    ensure =>  running,
  }
}
