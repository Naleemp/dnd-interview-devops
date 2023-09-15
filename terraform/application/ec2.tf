resource "aws_key_pair" "key" {
  key_name   = "application-example"
  public_key = local.public_key
}

resource "aws_key_pair" "key2" {
  key_name   = "application-example2"
  public_key = local.public_key2
}

## Web Instances

module "ec2_instance_web" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "example-web-${count.index}"
  # Microsoft Windows Server 2016 Base
  # ami-0791b6873db2bffc8 (64-bit (x86))
  #
  count                  = var.instance_count_web
  ami                    = var.ami
  instance_type          = var.ami_type
  key_name               = aws_key_pair.key2.key_name
  monitoring             = false
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.private_subnets, count.index)
  availability_zone      = element(var.availability_zones, count.index)
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sg.sg_web.security_group_id, data.terraform_remote_state.vpc.outputs.sg.sg_rdp.security_group_id, data.terraform_remote_state.vpc.outputs.sg.sg_alb.security_group_id, data.terraform_remote_state.vpc.outputs.sg.sg_intcommvms.security_group_id]

  associate_public_ip_address = false

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 150
    },
  ]

  ebs_block_device = [
    {
      device_name : "/dev/xvdg"
      volume_type = "gp2"
      volume_size = 40
    },
  ]

  metadata_options = {
    instance_metadata_tags = "enabled"
  }

  tags = merge(
    local.common_tags,
    {
      Name     = "example-web-${count.index}"
      Env      = "Private"
      Location = "Secret"
    }
  )
}

## App Instances

module "ec2_instance_app" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "example-app-${count.index}"
  # Microsoft Windows Server 2016 Base
  # ami-0791b6873db2bffc8 (64-bit (x86))
  #
  count                  = var.instance_count_app
  ami                    = var.ami
  instance_type          = var.ami_type
  key_name               = aws_key_pair.key2.key_name
  monitoring             = false
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.private_subnets, count.index)
  availability_zone      = element(var.availability_zones, count.index)
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sg.sg_web.security_group_id, data.terraform_remote_state.vpc.outputs.sg.sg_rdp.security_group_id, data.terraform_remote_state.vpc.outputs.sg.sg_alb.security_group_id, data.terraform_remote_state.vpc.outputs.sg.sg_intcommvms.security_group_id]

  associate_public_ip_address = false

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 100
    },
  ]

  ebs_block_device = [
    {
      device_name : "/dev/xvdg"
      volume_type = "gp2"
      volume_size = 40
    },
  ]

  metadata_options = {
    instance_metadata_tags = "enabled"
  }

  tags = merge(
    local.common_tags,
    {
      Name     = "example-app-${count.index}"
      Env      = "Private"
      Location = "Secret"
    }
  )
}

## Jump Host

module "ec2_instance_jumphost" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "example-jumphost-${count.index}"
  # Microsoft Windows Server 2016 Base
  # ami-0791b6873db2bffc8 (64-bit (x86))
  #
  count                  = var.instance_count_jumphost
  ami                    = var.ami
  instance_type          = var.ami_type
  key_name               = aws_key_pair.key2.key_name
  monitoring             = false
  subnet_id              = element(data.terraform_remote_state.vpc.outputs.public_subnets, count.index)
  availability_zone      = element(var.availability_zones, count.index)
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sg.sg_web.security_group_id, data.terraform_remote_state.vpc.outputs.sg.sg_rdp.security_group_id, data.terraform_remote_state.vpc.outputs.sg.sg_jumphost.security_group_id, data.terraform_remote_state.vpc.outputs.sg.sg_intcommvms.security_group_id]

  associate_public_ip_address = true

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = 150
    },
  ]

  metadata_options = {
    instance_metadata_tags = "enabled"
  }

  tags = merge(
    local.common_tags,
    {
      Name     = "example-jumphost${count.index}"
      Env      = "Private"
      Location = "Secret"
    }
  )
}