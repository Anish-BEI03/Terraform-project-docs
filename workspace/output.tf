output "ec2-public-ip" {
  value = aws_instance.terra-ec2.public_ip
  description = "Public IP address of the EC2 instance"
}

output "ec2-public-dns" {
  value = aws_instance.terra-ec2.public_dns
  description = "Public DNS name of the EC2 instance"
}
