resource "aws_instance" "puppetmaster" {
  ami           = "ami-02eac2c0129f6376b"
  instance_type = "t2.medium"

  vpc_security_group_ids = ["${var.webserver_sec_group}",
    "${aws_security_group.puppet_master_security_group.id}",
  ]

  key_name  = "${var.chef_key}"
  subnet_id = "${var.main_subnet}"

  root_block_device {
    volume_size           = "10"
    delete_on_termination = true
  }

  tags = {
    Name = "Puppet Master"
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
      "sudo /home/centos/setup/server_setup.sh puppet centos puppet_managed",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y puppetserver",
      "sudo systemctl enable puppetserver",
      "sudo systemctl start puppetserver",
      "git clone https://github.com/noliverio/iac.git",
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
  vpc_id = "${var.main_vpc}"
}

output "puppet_server_ip" {
  value = "${aws_instance.puppetmaster.public_ip}"
}
