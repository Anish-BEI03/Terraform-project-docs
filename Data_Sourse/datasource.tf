data "aws_ami" "ubuntu-ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "main" {
    tags = {
      Name = "my_vpc"
      environment="production"
    }
  }

  data "aws_subnet" "public_subnet" {
    filter {
        name = "tag:Name"
        values = ["my-public-subnet"]
    }
    filter {
        name = "tag:environment"
        values = ["production"]
    }
  }
  
  data "aws_security_group" "public-sg" {
    filter {
      name = "tag:Name"
      values = ["allow-http"]
    }
    filter {
      name = "tag:environment"
      values = ["production"]
    }
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.main.id]
    }
  }

output "ubuntu-ami-id" {
    value = data.aws_ami.ubuntu-ami.id
}
output "vpc-id" {
    value = data.aws_vpc.main.id
}
output "public-subnet-id" {
    value = data.aws_subnet.public_subnet.id
}
output "public-sg-id" {
    value = data.aws_security_group.public-sg.id
}