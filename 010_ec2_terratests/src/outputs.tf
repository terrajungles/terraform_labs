output "ami_id" {
  description = "AMI ID of Amazon Linux 2 in the specified region"
  value       = data.aws_ami.amazon_linux_2.id
}

output "instance_public_ip" {
  value       = module.aws_compute_instances.instance_public_ip[0]
  description = "Public IP of the AWS instance"
}

output "instance_public_dns" {
  value       = module.aws_compute_instances.instance_public_dns[0]
  description = "Public DNS of the AWS instance"
}

