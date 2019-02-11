resource "aws_instance" "bind_server" {
  ami           = "ami-02eac2c0129f6376b"
  instance_type = "t3.micro"

  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}",
    "${aws_security_group.dns_server_security_group.id}",
  ]

  key_name  = "${aws_key_pair.chef_key.key_name}"
  subnet_id = "${module.base_network.main_subnet}"

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
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
  security_group_id = "${aws_security_group.dns_server_security_group.id}"
}
