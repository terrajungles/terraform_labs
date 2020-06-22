terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

module "aws_compute_instances" {
  source = "./compute/"

  project             = var.project
  greeting_message    = var.greeting_message
  environment         = var.environment
  ingress_ports       = var.ingress_ports
  ami                 = data.aws_ami.amazon_linux_2.id
  instance_count      = 1
  tags                = local.common_tags
  instance_tag_prefix = "Ground-Terraform-Test"
}

locals {
  common_tags = {
    Department  = "Finance"
    Deployer    = "terraform"
    Project     = var.project
    Environment = var.environment
  }
}
