# Exercise code goes here
terraform {
  required_version = ">= 0.12"
}


provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http_th"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_instance" "sample" {
  count           = 2
  ami             = "ami-0a1c2ec61571737db"
  instance_type   = var.environment == "production" ? "t2.xlarge" : "t2.micro"
  security_groups = [aws_security_group.allow_http.name]
  user_data       = templatefile("./user_data.sh", { greeting_message = var.greeting_message })
  tags = merge(local.common_tags, {
    Name        = "Terraform-is-fun-th${count.index}"
  })
}

locals {
  common_tags = {
    Department = "GROUND TEAM"
    Deployer = "terraform"
    Project = "Dmmy project"
    Environment = var.environment
  }
}
