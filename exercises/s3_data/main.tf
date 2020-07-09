# Exercise code goes here - sj-terraform-test-bucket

terraform {
  required_version = ">= 0.12"
}


provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

data "aws_s3_bucket" "selected" {
  bucket = "sj-terraform-test-bucket"
}

output "id" {
    value = data.aws_s3_bucket.selected.id
}

output "arn" {
    value = data.aws_s3_bucket.selected.arn
}