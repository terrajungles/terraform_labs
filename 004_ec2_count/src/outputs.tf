output "ami_id" {
  description = "AMI ID of Amazon Linux 2 in the specified region"
  value       = data.aws_ami.amazon_linux_2.id
}

output "instance_public_ip" {
  value       = aws_instance.sample[0].public_ip
  description = "Public IP of the AWS instance"
}

output "instance_public_dns" {
  value       = aws_instance.sample[0].public_dns
  description = "Public DNS of the AWS instance"
}