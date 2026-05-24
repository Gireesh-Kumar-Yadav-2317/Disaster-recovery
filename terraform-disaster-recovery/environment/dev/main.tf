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

module "security_groups"{
  source = "../../modules/security-groups"

  project_name = var.project_name
  environment = var.environment
  vpc_id = module.vpc.vpc_id
  application_port = 80
  
}



module "ec2" {
  source = "../../modules/ec2"

  project_name = var.project_name
  environment = var.environment

  private_subnet_ids = values(module.vpc.private_subnet_ids)

  ec2_security_group_id = module.security_groups.ec2_security_group_id

  instance_profile_name = module.iam.ec2_instance_profile_name
  instance_type = "t3.micro"
  root_volume_size = 20
}

module "alb_asg" {

  source = "../../modules/alb-asg"

  project_name = var.project_name
  environment  = var.environment

  vpc_id = module.vpc.vpc_id

  public_subnet_ids = values(
    module.vpc.public_subnet_ids
  )

  private_subnet_ids = values(
    module.vpc.private_subnet_ids
  )

  alb_security_group_id = module.security_groups.alb_security_group_id

  launch_template_id = module.ec2.launch_template_id

  launch_template_version = module.ec2.launch_template_latest_version

  desired_capacity = 2

  min_size = 2

  max_size = 4
}


module "monitoring" {

  source = "../../modules/monitoring"

  project_name = var.project_name
  environment  = var.environment

  alb_arn_suffix = module.alb_asg.alb_arn_suffix

  autoscaling_group_name = module.alb_asg.autoscaling_group_name

  alert_email = "gireeshkumaryadav2317@gmail.com"
}




module "fis" {

  source = "../../modules/fis"

  project_name = var.project_name
  environment  = var.environment

  fis_role_arn = module.iam.fis_role_arn

  autoscaling_group_name = module.alb_asg.autoscaling_group_name
}