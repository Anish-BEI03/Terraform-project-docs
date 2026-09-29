# WE have an existing AWS VPC
/*
1. find the vpc
2. find the public subnet
3. find the latest ubuntu ami
4. create an EC2 instance
5. Output its ID and IP address
*/

resource "aws_instance" "nginx-web-server" {
  ami           = data.aws_ami.ubuntu-ami.id
  instance_type = "t3.micro"
  subnet_id     = data.aws_subnet.public_subnet.id
  vpc_security_group_ids = [data.aws_security_group.public-sg.id]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Welcome to Nginx webserver</h1>" | sudo tee /var/www/html/index.html
              EOF
  tags = {
    Name = "nginx-web-server"
    environment = "production"
  }
}

output "ec2-public-dns" {
    value = "http:// ${aws_instance.nginx-web-server.public_dns}"
}
