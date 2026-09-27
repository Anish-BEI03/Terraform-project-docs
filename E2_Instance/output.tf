output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web-server.public_ip # single output
}

output "ec2_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.web-server.public_dns
}

output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.web-server.private_ip
}

output "ec2_private_dns" {
  description = "Private DNS name of the EC2 instance"
  value       = aws_instance.web-server.private_dns
}


