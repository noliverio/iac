resource "aws_instance" "puppet_master" {
  ami                    = "ami-02eac2c0129f6376b"
  instance_type          = "t2.medium"
  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}"]
  key_name               = "${aws_key_pair.chef_key.key_name}"

  root_block_device {
    volume_size = "10"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y git",
      "sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm",
      "sudo yum install -y puppetserver",
      "sudo yum install -y puppet-agent",
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

resource "aws_instance" "puppet_client" {
  ami                    = "ami-02eac2c0129f6376b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}"]
  key_name               = "${aws_key_pair.chef_key.key_name}"

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm",
      "sudo yum install -y puppet-agent",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }
}

output "puppet_server_dns" {
  value = "${aws_instance.puppet_master.public_dns}"
}

output "puppet_client_dns" {
  value = "${aws_instance.puppet_client.public_dns}"
}
