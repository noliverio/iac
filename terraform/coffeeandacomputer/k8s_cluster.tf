resource "aws_instance" "node" {
  ami           = "ami-02eac2c0129f6376b"
  instance_type = "t3.micro"

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

  count = 4
}

output "node_public_ip${count.index}" {
  value = "${aws_instance.node.*.public_ip}"
}
