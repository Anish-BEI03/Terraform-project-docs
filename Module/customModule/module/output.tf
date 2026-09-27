
output "private_ips" {
  description = "Private IPs of the EC2 instances"
  value       = [for ins in aws_instance.infra-app : ins.private_ip]
}

output "public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = [for ins in aws_instance.infra-app : ins.public_ip]
}

output "instance_names" {
  description = "Instance names of the EC2 instances"
  value       = [for ins in aws_instance.infra-app : ins.tags.Name]
}

