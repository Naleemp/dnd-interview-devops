################################################################
# Security Groups - WEB
module "sg_web" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.16.2"
  name        = "secgrp-web"
  description = "Security group for allowing ICMP traffic to web instance, and allow outbound"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-icmp"]
  egress_rules        = ["all-all"]

  tags = local.common_tags
}

################################################################
# Security Groups - RDP
module "sg_rdp" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.16.2"
  name        = "secgrp-rdp"
  description = "Security group for allowing RDP traffic to web instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = var.rfc1918
  ingress_rules       = ["rdp-tcp"]

  tags = local.common_tags
}

################################################################
# Security Groups - RDS
module "sg_rds" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.16.2"
  name        = "secgrp-rds"
  description = "RDS MSSQL traffic"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = var.tgw_cidr_blocks
  ingress_rules       = ["all-icmp", "postgresql-tcp"]
  egress_rules        = ["all-all"]
  egress_cidr_blocks  = var.tgw_cidr_blocks
}


################################################################
# Security Groups - ALB
module "sg_alb" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.16.2"
  name        = "secgrp-alb"
  description = "Security group for usage with ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]


  tags = local.common_tags
}

################################################################
# Security Groups - ALB
module "sg_jumphost" {
  source      = "terraform-aws-modules/security-group/aws"
  version     = "4.16.2"
  name        = "secgrp-jumphost"
  description = "Jump host public allow list for RDP"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["15.222.152.1/32"]
  ingress_rules       = ["rdp-tcp"]


  tags = local.common_tags
}
