terraform {
  required_providers {
    aws={
        source ="hashicorp/aws"
        version ="~> 6.0"
    }
   
  }
}

provider "aws" {
    region = "us-east-1"
}



# create a vpc

resource "aws_vpc" "my-vpc-network" {
cidr_block = "10.0.0.0/16"
enable_dns_hostnames = true
enable_dns_support   = true  
tags = {
    Name = "my_vpc"
    environment = "production"
}
}

# create a public subnet

resource "aws_subnet" "my-public-subnet" {
  vpc_id     = aws_vpc.my-vpc-network.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "my-public-subnet"
    environment = "production"
  }
}

# create a private subnet

resource "aws_subnet" "my-private-subnet" {
  vpc_id     = aws_vpc.my-vpc-network.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "my-private-subnet"
    environment = "production"
  }
}

# create an internet gateway

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc-network.id
  tags = {
    Name = "my-igw"
    environment = "production"
  }
}

# create a public route table

resource "aws_route_table" "my-public-route-table" {
  vpc_id = aws_vpc.my-vpc-network.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
  tags = {
    Name = "my-public-route-table"
    environment = "production"
  }
}

# associate public route table with public subnet

resource "aws_route_table_association" "my-public-subnet-assoc" {
  route_table_id = aws_route_table.my-public-route-table.id
  subnet_id      = aws_subnet.my-public-subnet.id
}


# security group for public subnet

resource "aws_security_group" "allow-http" {
  vpc_id = aws_vpc.my-vpc-network.id
  tags = {
    Name = "allow-http"
    environment = "production"
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "vpc_id" {
  value = aws_vpc.my-vpc-network.id
}