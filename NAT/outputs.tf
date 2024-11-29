output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.nat[*].id
}

output "eip_ids" {
  description = "List of Elastic IP IDs associated with NAT Gateways"
  value       = aws_eip.nat[*].id
}
