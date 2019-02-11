provider "aws" {
  secret_key = "${var.secret_key}"
  access_key = "${var.access_key}"
  region     = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block = "10.10.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "10.10.0.0/24"
  map_public_ip_on_launch = "true"
}

resource "aws_internet_gateway" "main_gateway" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main_gateway.id}"
  }
}

resource "aws_route_table_association" "main_public_subnet" {
  subnet_id      = "${aws_subnet.main.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_security_group" "webserver" {
  vpc_id = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  security_group_id = "${aws_security_group.webserver.id}"
}

resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  security_group_id = "${aws_security_group.webserver.id}"
}

resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "tcp"
  security_group_id = "${aws_security_group.webserver.id}"
}

resource "aws_security_group_rule" "allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  cidr_blocks       = ["0.0.0.0/0"]
  protocol          = "all"
  security_group_id = "${aws_security_group.webserver.id}"
}

resource "aws_security_group_rule" "allow_ping" {
  type              = "ingress"
  protocol          = "icmp"
  to_port           = -1
  from_port         = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.webserver.id}"
}

output "webserver_sec_group" {
  value = "${aws_security_group.webserver.id}"
}

output "main_subnet" {
  value = "${aws_subnet.main.id}"
}

output "main_vpc" {
  value = "${aws_vpc.main.id}"
}
