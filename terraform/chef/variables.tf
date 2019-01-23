variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default ="us-east-1"
}

variable "public_key" {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCap/ZOaGOkMY+Ln49/MWMznzP1393nl/75CGJKsj0VDvBihyLnSOuhs7PtQjE5aVpl2ZnkVrr+vHZP16RyrVggntYLQBtG66gVYDM4sdKhmpS4jbPOqinDclWFFszedNWz+SSf0fVAbgDRpYSA3qFfAFjTJI/b9wXElhGNRBykCSMQ981t8PqXLdT9KPUA8KWmm6KzwJDaMRMfWSMgLyWL2Pe4EYzq1UU6Sa766hTNbthJcffeEBxEpg6+eMGcgZcvq/TyHTeoAW5riyOhqSw5Vo2HZ7hrlSjCPKY1YiCgTPyAEP5bdai1Ium9CPoFeKOHyHrQYIxij5+pSYx2LfrP"
}

variable "chef_server_install_url"{
    default = "https://packages.chef.io/files/stable/chef-server/12.18.14/el/7/chef-server-core-12.18.14-1.el7.x86_64.rpm"
}
