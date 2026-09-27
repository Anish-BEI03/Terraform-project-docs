
output "domain-name" {
  value = aws_instance.web.public_dns
}

output "application-url" {
  value = "http://${aws_instance.web.public_dns}"
}