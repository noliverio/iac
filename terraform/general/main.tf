terraform {
    backend "s3" {
        bucket = "noliverio-iac-terraform-backend"
        key = "state/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "noliverio-iac-terraform-backend-table"
#        encrypt = true
    }
}

provider "aws" {
    secret_key = "${var.secret_key}"
    access_key = "${var.access_key}"
    region = "${var.region}"
    version = "~> 1.56"

}

module "bootstrap"{
    source = "./bootstrap"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

module "base_network"{
    source = "./base_network"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
    
}



resource "aws_instance" "puppet_master"{
    ami = "ami-0922553b7b0369273"
    instance_type = "t2.medium"
    vpc_security_group_ids = ["${module.base_network.webserver_sec_group}"]
    key_name = "${aws_key_pair.chef_key.key_name}"

    root_block_device {
        volume_size = "10"   
    }

    provisioner "remote-exec"{
        inline = [
        "sudo yum update -y",
        "sudo yum install -y git",
        "sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm",
        "sudo yum install -y puppetserver",
        "sudo yum install -y puppet-agent",
        "sudo systemctl start puppetserver",
        ]

        connection {
            type = "ssh",
            user = "ec2-user",
            private_key = "${file("/home/ec2-user/chef_key.pem")}",
        }
    }
}

resource "aws_instance" "puppet_client"{
    ami = "ami-0922553b7b0369273"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${module.base_network.webserver_sec_group}"]
    key_name = "${aws_key_pair.chef_key.key_name}"


    provisioner "remote-exec"{
        inline = [
        "sudo yum update -y",
        "sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm",
        "sudo yum install -y puppet-agent",
        ]

        connection {
            type = "ssh",
            user = "ec2-user",
            private_key = "${file("/home/ec2-user/chef_key.pem")}",
        }
    }
}

resource "aws_key_pair" "chef_key" {
    public_key = "${var.public_key}"
}

output "server_dns" {
    value = "${aws_instance.puppet_master.public_dns}"
}

output "client_dns" {
    value = "${aws_instance.puppet_client.public_dns}"
}
