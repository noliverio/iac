node 'puppet.ec2.internal' {
  include puppet_master
  include ntp
}

node 'dns.ec2.internal' {
  include dns
  include ntp
  include puppet_agent
}
