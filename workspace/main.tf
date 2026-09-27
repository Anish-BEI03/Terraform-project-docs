# key-pair for ssh connection(login)

resource "aws_key_pair" "terra-key" {
    key_name = "${var.environment}-${var.key_name}"
    public_key = file("terra-ec2-key.pub")

    tags = {
      Environment = var.environment
    }
}

# vpc 

resource "aws_default_vpc" "default-vpc" {
  tags = {
    Name = "default-vpc"
  }
}

# security group for ssh connection

resource "aws_security_group" "ssh-sg" {
  name        = "${var.environment}-${var.ssh-sg.Name}"
  description = "Security group for ssh connection"
  vpc_id      = aws_default_vpc.default-vpc.id
 
  tags = {
    Name = "${var.environment}-ssh-sg"
    Environment = var.environment
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from anywhere"
    # Name = "web-port"
    # Type = "strings"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}


#Ec2_instance create

resource "aws_instance" "terra-ec2" {
  ami           = var.AMI_ID
  instance_type = var.INSTANCE_TYPE
  key_name      = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [aws_security_group.ssh-sg.id]
  tags = {
    Name = "web-instance-${var.environment}"
    Environment = var.environment
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    
  }
}