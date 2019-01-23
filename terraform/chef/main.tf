provider "aws" {
    secret_key = "${var.secret_key}"
    access_key = "${var.access_key}"
    region = "${var.region}"
}

resource "aws_instance" "chef_server"{
    ami = "ami-0922553b7b0369273"
    instance_type = "t2.medium"
    vpc_security_group_ids = ["${aws_security_group.webserver.id}"]
    key_name = "${aws_key_pair.chef_key.key_name}"

}

resource "aws_instance" "chef_client" {
    ami = "ami-0922553b7b0369273"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.webserver.id}"]
    key_name = "${aws_key_pair.chef_key.key_name}"
}

resource "aws_vpc" "default"{
    cidr_block = "10.10.0.0/16"    
}

resource "aws_internet_gateway" "default_gateway" {
    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_eip" "server_ip" {
    instance = "${aws_instance.chef_server.id}"

    provisioner "remote-exec"{
        inline = [
            "echo $(curl -s http://169.254.169.254/latest/meta-data/public-hostname)|xargs sudo hostname",
            "wget ${var.chef_server_install_url}",
            "sudo rpm -ivh chef-server-core-12.18.14-1.el7.x86_64.rpm",
            "rm chef-server-core-12.18.14-1.el7.x86_64.rpm", 
            "sudo chef-server-ctl reconfigure"
        ]
        connection = {
            host = "${aws_eip.server_ip.public_ip}"
            type = "ssh"
            user = "ec2-user"
            private_key = "${file("/home/ec2-user/chef_key.pem")}"
        }
    }
}

resource "aws_security_group" "webserver"{
}

resource "aws_security_group_rule" "allow_ssh"{
    type = "ingress"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    security_group_id = "${aws_security_group.webserver.id}"
}


resource "aws_security_group_rule" "allow_https"{
    type = "ingress"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    security_group_id = "${aws_security_group.webserver.id}"
}

resource "aws_security_group_rule" "allow_http"{
    type = "ingress"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
    security_group_id = "${aws_security_group.webserver.id}"
}

resource "aws_security_group_rule" "allow_all_out"{
    type = "egress"
    from_port = 0
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "all"
    security_group_id = "${aws_security_group.webserver.id}"
}

resource "aws_key_pair" "chef_key" {
    public_key = "${var.public_key}"
}


output "server_ip"{
    value = "${aws_eip.server_ip.public_ip}"
}


output "client_dns"{
    value = "${aws_instance.chef_client.public_dns}"
}
