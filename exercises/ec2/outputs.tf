output "public_ip" {
  value       = aws_instance.sample[*].public_ip
  description = "Public IP of the AWS instance"
}