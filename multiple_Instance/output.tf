/*
output "ec2_public_ips" {
  value = aws_instance.web-server[*].public_ip # [*] -> it allow to iterate over the list of instance and get the public ip of each instance 
}

output "ec2_public_dns" {
  value = aws_instance.web-server[*].public_dns # [*] -> multiple output
}
*/

output "ec2_public_ips" {
  value = [for instance in aws_instance.web-server : instance.public_ip]
}

output "ec2_public_dns" {
  value = [for instance in aws_instance.web-server : instance.public_dns]
}
