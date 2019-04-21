resource "aws_instance" "concourse_server" {
  ami                    = "ami-02eac2c0129f6376b"
  instance_type          = "t3.micro"
  subnet_id              = "${module.base_network.main_subnet}"
  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}"]
  key_name               = "${aws_key_pair.chef_key.key_name}"

  tags = {
    Name = "concourse-server"
  }

  provisioner "file" {
    source      = "setup_files"
    destination = "/home/centos/setup/"

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 777 /home/centos/setup/server_setup.sh",
      "sudo /home/centos/setup/server_setup.sh concourse centos interactive_server",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y wget",
      "wget https://github.com/concourse/concourse/releases/download/v4.2.2/concourse_linux_amd64",
      "chmod 744 concourse_linux_amd64",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }
}

output "concourse_server_dns" {
  value = "${aws_instance.concourse_server.public_dns}"
}
