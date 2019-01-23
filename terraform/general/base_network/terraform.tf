 provider "aws" {
    secret_key = "${var.secret_key}"
    access_key = "${var.access_key}"
    region = "${var.region}"
}

resource "aws_vpc" "default"{
    cidr_block = "10.10.0.0/16"    
}

resource "aws_internet_gateway" "default_gateway" {
    vpc_id = "${aws_vpc.default.id}"
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

output "webserver_sec_group" {
    value = "${aws_security_group.webserver.id}"
}
