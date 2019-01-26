class webserver {
  
  package { 'httpd':
    ensure => 'present',
  }

  $page_hash =  {
    'host_os' => $facts['os']['family'], 
  }

  file { '/var/http/index.html':
    ensure  =>  'file',
    content => epp('webserver/index.html.epp', )
  
  }

  service { 'httpd':
    ensure => 'running',
  }
}
