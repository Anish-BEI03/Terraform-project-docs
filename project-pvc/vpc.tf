
# create a vpc

resource "aws_vpc" "my-vpc-network" {
cidr_block = "10.0.0.0/16"
enable_dns_hostnames = true // enable public dns hostnames for instances
enable_dns_support   = true // enable dns support for instances
tags = {
    Name = "my_vpc"
}
}

# create a public subnet

resource "aws_subnet" "my-public-subnet" {
  vpc_id                  = aws_vpc.my-vpc-network.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true // enable public ip on launch
  
  tags = {
    Name = "my-public-subnet"
  }
}

# create a private subnet

resource "aws_subnet" "my-private-subnet" {
  vpc_id     = aws_vpc.my-vpc-network.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "my-private-subnet"
  }
}

# create an internet gateway

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc-network.id
  tags = {
    Name = "my-igw"
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
  }
}

# associate public route table with public subnet

resource "aws_route_table_association" "my-public-subnet-assoc" {
  route_table_id = aws_route_table.my-public-route-table.id
  subnet_id      = aws_subnet.my-public-subnet.id
}
