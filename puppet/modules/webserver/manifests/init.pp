class webserver (
  $hostname = $facts['hostname'] 
){
  
  package { 'httpd':
    ensure => 'present',
  }

  $page_hash = {
    'hostname' => $hostname,
  }

  file { '/var/http/index.html':
    content => epp('webserver/index.html.epp', $page_hash ),
    notify  => Service['httpd'],
  }

  service { 'httpd':
    ensure => 'running',
  }
}
