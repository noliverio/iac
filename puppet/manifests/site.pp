node 'puppet.coffeeandacomputer.local' {
  include puppet_master
  include ntp
}

node 'primary-dns.coffeeandacomputer.local' {
  include primary_dns
  include ntp
  include network_default
}

node 'secondary-dns.coffeeandacomputer.local' {
  include secondary_dns
  include ntp
  include network_default
}
