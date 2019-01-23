terraform {
   backend "s3" {
       bucket = "noliverio-iac-terraform-backend"
       key = "state/terraform.tfstate"
       region = "us-east-1"
       dynamodb_table = "noliverio-iac-terraform-backend-table"
   }
}

module "bootstrap" {
    source = "./bootstrap"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}

#resource "aws_vpc" "test_cloud"{
#    cidr_block = "10.0.0.0/16"
#}
#
#resource "aws_internet_gateway" "gw" {
#    vpc_id = "${aws_vpc.test_cloud.id}"
#}
#
#resource "aws_subnet" "main"{
#    cidr_block = "10.0.0.0/24"
#    vpc_id = "${aws_vpc.test_cloud.id}"
#}
#
#resource "aws_subnet" "back"{
#    cidr_block = "10.0.1.0/24"
#    vpc_id = "${aws_vpc.test_cloud.id}"
#}
#resource "aws_instance" "test_server"{
#    count = 3
#    ami = "ami-2757f631"
#    instance_type = "t2.micro"
#    subnet_id = "${aws_subnet.main.id}"
#}
#resource "aws_instance" "test_server_back"{
#    ami = "ami-2757f631"
#    instance_type = "t2.micro"
#    subnet_id = "${aws_subnet.back.id}"
#}
#
#resource "aws_lb_listener" "test_listener" {
#    load_balancer_arn = "${aws_lb.test_alb.arn}"
#    port = "80"
#    protocol = "HTTP"
#    default_action {
#        type = "forward"
#        target_group_arn = "${aws_lb_target_group.test_lb_group.arn}"
#    }
#}
#
#resource "aws_lb_target_group" "test_lb_group"{
#    name_prefix = "group"
#    port = 80
#    protocol = "HTTP"
#    vpc_id = "${aws_vpc.test_cloud.id}"
#}
#
#resource "aws_lb_target_group_attachment" "test_lb_attach_1"{
#    target_group_arn = "${aws_lb_target_group.test_lb_group.arn}"
#    target_id = "${aws_instance.test_server.0.id}"
#}
#resource "aws_lb_target_group_attachment" "test_lb_attach_2"{
#    target_group_arn = "${aws_lb_target_group.test_lb_group.arn}"
#    target_id = "${aws_instance.test_server.1.id}"
#}
#resource "aws_lb_target_group_attachment" "test_lb_attach_3"{
#    target_group_arn = "${aws_lb_target_group.test_lb_group.arn}"
#    target_id = "${aws_instance.test_server.2.id}"
#}
#
#resource "aws_lb_target_group_attachment" "test_back_lb_attach_4"{
#    target_group_arn = "${aws_lb_target_group.test_lb_group.arn}"
#    target_id = "${aws_instance.test_server_back.id}"
#}
#
#resource "aws_lb" "test_alb" {
#    name = "test-terraform-lb"
#    internal = false
#    load_balancer_type = "application"
#    subnets = ["${aws_subnet.main.id}","${aws_subnet.back.id}"]
#}
#
