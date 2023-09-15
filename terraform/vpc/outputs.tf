# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "database_subnet_group" {
  description = "Subnet group for the database subnets"
  value       = module.vpc.database_subnet_group
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "sg" {
  value = {
    sg_rds        = module.sg_rds
    sg_alb        = module.sg_alb
    sg_web        = module.sg_web
    sg_rdp        = module.sg_rdp
    sg_jumphost   = module.sg_jumphost
  }
}
