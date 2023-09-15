provider "aws" {
  region = local.project_region
}
terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = ">=4.67.0"
    }
  }
}