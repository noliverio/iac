resource "aws_instance" "concourse_server" {
  ami                    = "ami-02eac2c0129f6376b"
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["${module.base_network.webserver_sec_group}"]
  key_name               = "${aws_key_pair.chef_key.key_name}"

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("/home/ec2-user/chef_key.pem")}"
    }
  }
}
