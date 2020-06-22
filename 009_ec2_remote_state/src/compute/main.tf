resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_ports
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name        = "allow_http"
  })
}

resource "aws_instance" "sample" {
  count           = var.instance_count
  ami             = var.ami
  instance_type   = var.environment == "production" ? "t2.xlarge" : "t2.micro"
  security_groups = [aws_security_group.allow_http.name]

  user_data = templatefile("./user_data.sh", {
    greeting_message = var.greeting_message
  })

  tags = merge(var.tags, {
    Name        = "${var.instance_tag_prefix}-${count.index}"
  })
}