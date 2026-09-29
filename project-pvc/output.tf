
output "application-url"{
value= "http://${aws_instance.web-server.public_dns}"
}