terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.0"
  region  = "ap-northeast-1"
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "allow_http"
    Project     = var.project
    Environment = var.environment
    Label = "002_ec2_part_2"
  }
}

resource "aws_instance" "sample" {
  ami             = "ami-0a1c2ec61571737db"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_http.name]

  user_data = templatefile("./user_data.sh", {
    greeting_message = var.greeting_message
  })

  tags = {
    Name        = "Ground-Terraform-Test"
    Project     = var.project
    Deployer    = "terraform"
    Environment = var.environment
    Label = "002_ec2_part_2"
  }
}