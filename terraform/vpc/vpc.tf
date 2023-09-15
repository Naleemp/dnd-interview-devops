resource "aws_eip" "nat" {
  count = 1

  vpc = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "application-example"
  cidr = var.vpc_cidr_block

  azs                     = var.vpc_availability_zones
  private_subnets         = [cidrsubnet(var.vpc_cidr_block, 3, 0), cidrsubnet(var.vpc_cidr_block, 3, 1)]
  database_subnets        = [cidrsubnet(var.vpc_cidr_block, 3, 2), cidrsubnet(var.vpc_cidr_block, 4, 9)]
  public_subnets          = [cidrsubnet(var.vpc_cidr_block, 4, 6), cidrsubnet(var.vpc_cidr_block, 4, 7)]
  enable_nat_gateway      = true
  map_public_ip_on_launch = true
  single_nat_gateway      = true
  one_nat_gateway_per_az  = false
  reuse_nat_ips           = true
  external_nat_ip_ids     = aws_eip.nat.*.id
  enable_dns_hostnames    = false
  tags                    = local.common_tags

}

module "sg_vpc_endpoint" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.16.2"
  name        = "secgrp-vpcendpoint"
  description = "VPC Endpoint Traffic security group"
  vpc_id      = module.vpc.vpc_id

  # ingress_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      description = "Allow traffic from VPC private subnet to VPC endpoint"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]

  tags = local.common_tags
}


################################################################################
# Transit Gateway Assocation and route table entries
################################################################################
# Transit Gateway Assocation and route table entries
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_tgw_attachment" {
  subnet_ids         = module.vpc.private_subnets
  transit_gateway_id = var.tgw_id
  vpc_id             = module.vpc.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "vpctga-hub"
    }
  )
}

resource "aws_route" "tgw_routes" {
  count = length(var.tgw_cidr_blocks)

  route_table_id         = module.vpc.private_route_table_ids[0]
  destination_cidr_block = var.tgw_cidr_blocks[count.index]
  transit_gateway_id     = var.tgw_id

  timeouts {
    create = "5m"
  }
}