variable "access_key" {}
variable "secret_key" {}

variable "main_subnet" {}
variable "main_vpc" {}
variable "webserver_sec_group" {}
variable "chef_key" {}

variable "region" {
  default = "us-east-1"
}
