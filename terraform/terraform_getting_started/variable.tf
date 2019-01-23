# Get access_key and secret_keys from environmental vars
variable "ACCESS_KEY" {}
variable "SECRET_KEY" {}

variable "region" {
    default = "us-east-1"
}
#adding amis variable to support deploying the ami in different regions.
variable "amis" {
    type = "map"
    default = {
        "us-east-1" = "ami-b374d5a5"
        "us-west-2" = "ami-4b32be2b"
    }
}
