locals {
  azs = var.azs

  name_prefix = "${var.project_name}-vpc"

  public_subnet_cidrs = [
    for i in range(length(local.azs)) :
    cidrsubnet(var.cidr_block, 4, i)
  ]

  private_subnet_cidrs = [
    for i in range(length(local.azs)) :
    cidrsubnet(var.cidr_block, 4, i + length(local.azs))
  ]

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}