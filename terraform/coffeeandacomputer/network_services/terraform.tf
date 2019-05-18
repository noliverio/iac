provider "aws" {
  secret_key = "${var.secret_key}"
  access_key = "${var.access_key}"
  region     = "${var.region}"
}
