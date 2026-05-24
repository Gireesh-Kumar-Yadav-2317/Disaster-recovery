locals {

  name_prefix = "${var.project_name}-${var.environment}"

  azs = var.azs

  public_subnets = {
    for idx, az in local.azs :
    az => {
      cidr = cidrsubnet(var.cidr_block, 4, idx)
      az   = az
    }
  }

  private_subnets = {
    for idx, az in local.azs :
    az => {
      cidr = cidrsubnet(var.cidr_block, 4, idx + length(local.azs))
      az   = az
    }
  }

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Module      = "VPC"
  }
}