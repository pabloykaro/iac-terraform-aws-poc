output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.main.id
}

output "network_public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = aws_subnet.network_public[*].id
}

output "network_private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = aws_subnet.network_private[*].id
}

output "rds_security_group_id" {
  description = "ID do security group do RDS"
  value       = aws_security_group.rds_security_group.id
}






