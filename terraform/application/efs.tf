data "aws_vpc" "main" {
  id = [data.terraform_remote_state.vpc.outputs.vpc_id][0]
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  tags = {
    Name = var.private_subnet_tag
  }
}

data "aws_subnet" "privateid" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

module "efs" {
  source = "terraform-aws-modules/efs/aws"

  # File system
  name           = "example"
  creation_token = "example-token"

  performance_mode                = "maxIO"
  throughput_mode                 = "provisioned"
  provisioned_throughput_in_mibps = 256

  lifecycle_policy = {
    transition_to_ia = "AFTER_30_DAYS"
  }

  # File system policy
  attach_policy                      = true
  bypass_policy_lockout_safety_check = false
  policy_statements = [
    {
      sid     = "example"
      actions = ["elasticfilesystem:ClientMount"]
      principals = [
        {
          type        = "AWS"
          identifiers = ["arn:aws:iam::12345678:role/EFSReadOnly"]
        }
      ]
    }
  ]

  # Mount targets / security group
  mount_targets = {
    element(var.availability_zones, 0) = {
      subnet_id = element(data.terraform_remote_state.vpc.outputs.private_subnets, 0)
    }
    element(var.availability_zones, 1) = {
      subnet_id = element(data.terraform_remote_state.vpc.outputs.private_subnets, 1)
    }
  }
  security_group_description = "Example EFS security group"
  security_group_vpc_id      = [data.terraform_remote_state.vpc.outputs.vpc_id][0]
  security_group_rules = {
    vpc = {
      #cidr_blocks = [data.aws_vpc.main.cidr_block]
      cidr_blocks = [for s in data.aws_subnet.privateid : s.cidr_block]
    }
  }

  # Access point(s)
  access_points = {
    root_example = {
      root_directory = {
        path = "/webapp"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "755"
        }
      }
    }
  }

  # Backup policy
  enable_backup_policy = true

  tags = {
    Terraform   = "true"
    Environment = "example"
  }
}