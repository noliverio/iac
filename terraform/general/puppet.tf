resource "aws_instance" "puppetmaster" {
  ami           = "ami-02eac2c0129f6376b"
  instance_type = "t2.medium"

  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}",
    "${aws_security_group.puppet_master_security_group.id}",
  ]

  key_name = "${aws_key_pair.chef_key.key_name}"

  root_block_device {
    volume_size = "10"
  }

  subnet_id = "${module.base_network.main_subnet}"

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y git",
      "sudo yum install -y ntp",
      "sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm",
      "sudo yum install -y puppetserver",
      "sudo yum install -y puppet-agent",
      "sudo echo puppet > /etc/hostname",
      "sudo systemctl enable puppetserver",
      "sudo systemctl start puppetserver",
      "sudo systemctl start ntpd",
      "git clone https://github.com/noliverio/iac.git",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }
}

resource "aws_instance" "puppet_client" {
  ami                    = "ami-02eac2c0129f6376b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}"]
  key_name               = "${aws_key_pair.chef_key.key_name}"
  subnet_id              = "${module.base_network.main_subnet}"

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm",
      "sudo yum install -y puppet-agent",
      "sudo echo puppetagent > /etc/hostname",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }
}

resource "aws_security_group_rule" "allow_puppet_communication" {
  type              = "ingress"
  from_port         = 8140
  to_port           = 8140
  protocol          = "tcp"
  cidr_blocks       = ["10.10.0.0/16"]
  security_group_id = "${aws_security_group.puppet_master_security_group.id}"
}

resource "aws_security_group" "puppet_master_security_group" {
  vpc_id = "${module.base_network.main_vpc}"
}

output "puppet_server_dns" {
  value = "${aws_instance.puppetmaster.public_dns}"
}

output "puppet_client_dns" {
  value = "${aws_instance.puppet_client.public_dns}"
}
