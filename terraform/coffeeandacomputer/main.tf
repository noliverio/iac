terraform {
  backend "s3" {
    bucket         = "noliverio-iac-terraform-backend"
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "noliverio-iac-terraform-backend-table"
    encrypt        = true
  }
}

provider "aws" {
  secret_key = "${var.secret_key}"
  access_key = "${var.access_key}"
  region     = "${var.region}"
  version    = "~> 1.56"
}

module "bootstrap" {
  source     = "./bootstrap"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "base_network" {
  source     = "./base_network"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

module "network_services" {
  source              = "./network_services"
  access_key          = "${var.access_key}"
  secret_key          = "${var.secret_key}"
  region              = "${var.region}"
  main_subnet         = "${module.base_network.main_subnet}"
  main_vpc            = "${module.base_network.main_vpc}"
  webserver_sec_group = "${module.base_network.webserver_sec_group}"
  chef_key            = "${aws_key_pair.chef_key.id}"
}

resource "aws_key_pair" "chef_key" {
  public_key = "${var.public_key}"
}
