# Create Elastic IPs for the NAT Gateway
resource "aws_eip" "nat" {
  for_each = toset(var.public_subnet_ids)

  tags = {
    Name = "NAT Gateway EIP for Subnet ${each.value}"
  }
}

# Create NAT Gateways in public subnets
resource "aws_nat_gateway" "nat" {
  for_each       = toset(var.public_subnet_ids)
  allocation_id  = aws_eip.nat[each.key].id
  subnet_id      = each.value
  connectivity_type = "public" # Public NAT Gateway

  tags = {
    Name = "NAT Gateway for Subnet ${each.value}"
  }
}

# Add routes to private route tables
resource "aws_route" "private_to_nat" {
  for_each             = toset(var.private_route_table_ids)
  route_table_id       = each.value
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id       = aws_nat_gateway.nat[each.key].id
}
