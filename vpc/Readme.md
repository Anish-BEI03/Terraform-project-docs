# concept idea for production vpc

vpc ->subnet->route table -> internet gateway -> internet

# Create AWS VPC with CIDR block 10.0.0.0/16

```
aws_vpc
    ↓
AWS VPC resource

cidr_block
    ↓
Network range

```

```bash
# create VPC with CIDR block 10.0.0.0/16
resource "aws_vpc" "my-vpc-1" {
  cidr_block           = "10.0.0.0/16"
  tags = {
    Name = "my-vpc-1"
  }
}
```

# subnet

```
             VPC
       10.0.0.0/16
             │
       ┌─────┴─────┐
       ↓           ↓
 Public Subnet   Private Subnet
10.0.1.0/24     10.0.2.0/24

```

## create public subnet with CIDR block 10.0.1.0/24 in us-east-1a

```bash
resource "aws_subnet" "my-public-subnet-1" {
  vpc_id     = aws_vpc.my-vpc-1.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "my-public-subnet-1"
  }
}
```

## create private subnet with CIDR block 10.0.2.0/24 in us-east-1a

```bash
resource "aws_subnet" "my-private-subnet-1" {
  vpc_id     = aws_vpc.my-vpc-1.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "my-private-subnet-1"
  }
}
```

# internet gateway

```
add internet gateway to VPC for internet access

Internet
    │
    ↓
Internet Gateway
    │
    ↓
   VPC
    │
    ↓
Public Subnet
```

## add internet gateway to VPC for internet access

```bash
resource "aws_internet_gateway" "my-internet-gateway" {
  vpc_id = aws_vpc.my-vpc-1.id
  tags = {
    Name = "my-internet-gateway"
  }
}
```

# route table

```
create public route table for public subnet

0.0.0.0/0
      ↓
Internet Gateway



create private route table for private subnet
```

## create public route table for public subnet

```bash
resource "aws_route_table" "my-public-route-table" {
  vpc_id = aws_vpc.my-vpc-1.id
  route {
    cidr_block = "[0.0.0.0/0]"
    gateway_id = aws_internet_gateway.my-internet-gateway.id
  }
  tags = {
    Name = "my-public-route-table"
  }
}
```

## create private route table for private subnet

```bash
resource "aws_route_table" "my-private-route-table" {
  vpc_id = aws_vpc.my-vpc-1.id

}
```

# Configure Route Table Associations to Subnets

```bash
#associate public route table with public subnet

Public Subnet
      ↓
Public Route Table
      ↓
Internet Gateway
      ↓
Internet

#associate private route table with private subnet

Private Subnet
      ↓
Private Route Table
      ↓
     VPC
      ↓
Private Subnet
```

```bash
resouce "aws_route_table_association" "my-public-route-table-association" {
  route_table_id = aws_route_table.my-public-route-table.id
  subnet_id      = aws_subnet.my-public-subnet-1.id
}
```

# production vpc architecture

```
                    Internet
                      │
                      ↓
                Internet Gateway
                      │
             ┌────────┴────────┐
             │      VPC         │
             │  10.0.0.0/16     │
             │                  │
             │ ┌──────────────┐ │
             │ │Public Subnet │ │
             │ │10.0.1.0/24   │ │
             │ │              │ │
             │ │ Load Balancer│ │
             │ └──────┬───────┘ │
             │        │         │
             │ ┌──────▼───────┐ │
             │ │Private Subnet│ │
             │ │10.0.2.0/24   │ │
             │ │              │ │
             │ │ Application  │ │
             │ └──────┬───────┘ │
             │        │         │
             │ ┌──────▼───────┐ │
             │ │Private Subnet│ │
             │ │10.0.3.0/24   │ │
             │ │              │ │
             │ │   Database   │ │
             │ └──────────────┘ │
             └──────────────────┘

```
