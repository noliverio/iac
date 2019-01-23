terraform {
    backend "s3" {
        bucket = "noliverio-iac-terraform-backend"
        key = "state/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "noliverio-iac-terraform-backend-table"
    }
}

provider "aws" {
    secret_key = "${var.secret_key}"
    access_key = "${var.access_key}"
    region = "us-east-1"
    version = "~> 1.41"
}

resource "aws_s3_bucket" "backend_bucket"{
    bucket = "noliverio-iac-terraform-backend"
    logging {
        target_bucket = "${aws_s3_bucket.logging_bucket.id}"
        target_prefix = "/terraform_backend"
    }
    versioning {
        enabled = true
    }
    server_side_encryption_configuration {
        rule{
            apply_server_side_encryption_by_default{
                sse_algorithm = "AES256"
            }   
        }
    }
    depends_on = ["aws_s3_bucket.logging_bucket"]
}

resource "aws_s3_bucket" "logging_bucket" {
    bucket = "noliverio-iac-logs"
    acl = "log-delivery-write"
}

#Dynamo table for locking terraform state file
resource "aws_dynamodb_table" "backend_table" {
    name = "noliverio-iac-terraform-backend-table"
    hash_key = "LockID"
    read_capacity = 5
    write_capacity = 5
    attribute{
        name = "LockID"
        type = "S"
    }
}

#Provision the terraform iam user and attach policies needed
resource "aws_iam_user" "terraform_user" {
    name = "terraform"
}

