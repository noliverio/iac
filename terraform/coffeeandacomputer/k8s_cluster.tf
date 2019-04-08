resource "aws_instance" "node" {
  ami           = "ami-02eac2c0129f6376b"
  instance_type = "t2.medium"

  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}"]

  key_name  = "${aws_key_pair.chef_key.key_name}"
  subnet_id = "${module.base_network.main_subnet}"

  tags = {
    Name = "node${count.index}"
  }

  provisioner "file" {
    source      = "setup_files"
    destination = "/home/centos/setup"

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /home/centos/setup/server_setup.sh",
      "sudo /home/centos/setup/server_setup.sh node centos interactive_server",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }

  count = 6
}

resource "aws_security_group" "kubernetes_security_group" {
  vpc_id = "${module.base_network.main_vpc}"
}

// For ease's sake allow all communication between k8s nodes.
resource "aws_security_group_rule" "allow_kubernetes_internode_communication_tcp" {
  type                     = "ingress"
  source_security_group_id = "{$aws_security_group.kubernetes_security_group.id}"
  from_port                = "0"
  to_port                  = "65535"
  protocol                 = "tcp"
}

output "node_public_ip${count.index}" {
  value = "${aws_instance.node.*.public_ip}"
}
