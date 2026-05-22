module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  cidr_block   = var.cidr_block

  azs = var.azs

  enable_nat_gateway = true

  single_nat_gateway = false
}


module "iam" {

  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment
}