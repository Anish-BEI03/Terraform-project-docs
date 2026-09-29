# project: vpc+ EC2 + Nginx + Http access through internet 

#security group

resource "aws_security_group" "allow-http" {
vpc_id = aws_vpc.my-vpc-network.id
  name        = "allow-http-ssh"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-http"
  }
}

# create an EC2 instance
resource "aws_instance" "web-server" {
  ami           = "ami-0b6d9d3d33ba97d99"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.my-public-subnet.id
  vpc_security_group_ids = [aws_security_group.allow-http.id]
  associate_public_ip_address = true // enable public ip on launch
  

 user_data = file("install_package.sh")

  tags = {
    Name = "web-server"
  }
}