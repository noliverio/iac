resource "aws_instance" "primary_nameserver" {
  ami           = "ami-02eac2c0129f6376b"
  instance_type = "t3.micro"

  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}",
    "${aws_security_group.dns_server_security_group.id}",
  ]

  key_name  = "${aws_key_pair.chef_key.key_name}"
  subnet_id = "${module.base_network.main_subnet}"

  provisioner "file" {
    source      = "setup_files/server_setup.sh"
    destination = "/home/centos/setup.sh"

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /home/centos/setup.sh",
      "sudo /home/centos/setup.sh primary_dns.coffeeandacomputer.com centos interactive_server ",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }
}

resource "aws_instance" "secondary_nameserver" {
  ami           = "ami-02eac2c0129f6376b"
  instance_type = "t3.micro"

  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}",
    "${aws_security_group.dns_server_security_group.id}",
  ]

  key_name  = "${aws_key_pair.chef_key.key_name}"
  subnet_id = "${module.base_network.main_subnet}"

  provisioner "file" {
    source      = "setup_files/server_setup.sh"
    destination = "/home/centos/setup.sh"

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /home/centos/setup.sh",
      "sudo /home/centos/setup.sh secondary_dns.coffeeandacomputer.com centos interactive_server ",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }
}

resource "aws_security_group" "dns_server_security_group" {
  vpc_id = "${module.base_network.main_vpc}"
}

resource "aws_security_group_rule" "allow_dns_lookup" {
  type              = "ingress"
  from_port         = "53"
  to_port           = "53"
  protocol          = "udp"
  cidr_blocks       = ["10.10.0.0/24"]
  security_group_id = "${aws_security_group.dns_server_security_group.id}"
}

output "primary_dns_public_ip" {
  value = "${aws_instance.primary_nameserver.public_ip}"
}

output "secondary_dns_public_ip" {
  value = "${aws_instance.secondary_nameserver.public_ip}"
}
