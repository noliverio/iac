class workstation {
  include network_default
  package {'vim':
    ensure =>  present,
  }
  package { 'wget':
    ensure =>  present,
  }

}
