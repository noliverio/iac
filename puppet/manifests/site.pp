node 'puppet.coffeeandacomputer.local' {
  include puppet_master
  include network_default
}

node 'primary-dns.coffeeandacomputer.local' {
  include primary_dns
  include network_default
}

node 'secondary-dns.coffeeandacomputer.local' {
  include secondary_dns
  include network_default
}

node 'blog.coffeeandacomputer.local' {
  class{ reverse_proxy:
    destination => 'http://blog.coffeeandacomputer.com.s3-website-us-east-1.amazonaws.com'
  }
  include network_default
}
