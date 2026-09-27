# key-pair (login)
resource "aws_key_pair" "ssh-key" {
  key_name   = "${var.Env}-infra-app-key"
  public_key = file(var.key_value)

  tags = {
    Name        = "${var.Env}-infra-app-key"
    Environment = var.Env
  }
}

# vpc default
resource "aws_default_vpc" "default" {
  tags = {
    Name        = "${var.Env}-default-vpc"
    Environment = var.Env
  }
}

# security group
resource "aws_security_group" "infra-app-sg" {
  name        = "${var.Env}-infra-app-sg"
  vpc_id      = aws_default_vpc.default.id
  description = "allow ssh and all egress traffic"


  # ingress
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.Env}-infra-app-sg"
    Environment = var.Env
  }
}


resource "aws_instance" "infra-app" {

  count = var.instance_count

  depends_on = [
    aws_key_pair.ssh-key,
    aws_security_group.infra-app-sg
  ]

  key_name               = aws_key_pair.ssh-key.key_name
  vpc_security_group_ids = [aws_security_group.infra-app-sg.id]

  ami           = var.ami-id
  instance_type = var.instance_type

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.Env}-infra-app-${count.index}"
    Environment = var.Env
  }
}
