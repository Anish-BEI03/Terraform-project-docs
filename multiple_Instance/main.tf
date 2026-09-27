# key-value pair

resource "aws_key_pair" "terra-key" {
  key_name   = var.key_name
  public_key = file("terra-key-ec2.pub")

}

# vpc default

resource "aws_default_vpc" "default_vpc" {}

# security group default
resource "aws_security_group" "my-sg" {
  vpc_id      = aws_default_vpc.default_vpc.id
  name        = var.tags-sg.Name
  tags        = var.tags-sg
  description = "allow ssh and http access"


  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "all outgoing traffic"
    }

  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "ssh access"
    }

  
}

# Ec2 instance

resource "aws_instance" "web-server" {

  #count = 2 # meta argument for multiple instance creation
  for_each = toset(var.instance_names)

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.terra-key.key_name
  security_groups = [aws_security_group.my-sg.name]

  tags = {
    Name = each.key
  }


 # Meta argument for multiple instance creation
 # it ensure that the instance are created only after the security group and key pair are created

 depends_on = [ aws_security_group.my-sg, aws_key_pair.terra-key]

  root_block_device {
    volume_size = var.env == "prod" ? 20 : var.volume_default_size # conditional operator
    volume_type = "gp3"

  }
}

# import existing resource that running in AWS but not in terraform code
# first find the instance id of the existing resource
# then run terraform import command
/*
syntax: terraform import [resource_type].[resource_name] [instance_id]

example:
terraform import aws_instance.web-server-4 i-0123456789abcdef0

then run terraform plan and terraform apply
*/




resource "aws_instance" "web-server-4" {
    ami = "unknown"
    instance_type ="unknown"
    key_name = "unknown"
    tags = {
      Name = "web-server-4"
    }
  
}

