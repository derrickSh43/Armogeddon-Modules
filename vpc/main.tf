// create a new vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_tags
  }
}

// create a public subnet
resource "aws_subnet" "public" {
  for_each = toset(var.azs) # Create one subnet per AZ
  vpc_id   = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[tonumber(each.key)]

  availability_zone = each.value

  tags = {
    Name = "Public Subnet in ${each.value}"
  }
}

// create a private subnet
resource "aws_subnet" "private" {
  for_each = toset(var.azs) # Create one subnet per AZ
  vpc_id   = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[tonumber(each.key)]

  availability_zone = each.value

  tags = {
    Name = "Private Subnet in ${each.value}"
  }
}

// create internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Internet Gateway"
  }
}
// Create a route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Allow internet traffic
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

// Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

// Create a route table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Private Route Table"
  }
}

// Associate private subnets with the private route table
resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}



