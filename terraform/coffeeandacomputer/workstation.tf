resource "aws_instance" "workstation" {
  ami           = "ami-0a313d6098716f372"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}"]

  key_name  = "${aws_key_pair.chef_key.key_name}"
  subnet_id = "${module.base_network.main_subnet}"

  tags = {
    Name = "Workstation"
  }

  provisioner "file" {
    source      = "setup_files"
    destination = "/home/ubuntu/setup"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /home/ubuntu/setup/server_setup.sh",
      "sudo /home/ubuntu/setup/server_setup.sh workstation ubuntu interactive_server",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }
}

output "workstation_public_ip" {
  value = "${aws_instance.workstation.public_ip}"
}
