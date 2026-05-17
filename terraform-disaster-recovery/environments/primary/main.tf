data "aws_availability_zones" "available" {}

module "vpc" {
  source = "../../modules/vpc"

  cidr_block   = var.vpc_cidr
  project_name = var.project
  environment  = "dev"

  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}