module "vpc" {
  source = "../../modules/vpc"

  providers = {
    aws = aws.primary
  }

  project_name = var.project_name
  environment  = var.environment
  cidr_block   = var.cidr_block

  azs = var.azs

  enable_nat_gateway = true

  single_nat_gateway = false
}


module "iam" {

  source = "../../modules/iam"

  providers = {
    aws = aws.primary
  }

  project_name = var.project_name
  environment  = var.environment
}

module "security_groups" {
  source = "../../modules/security-groups"
  providers = {
    aws = aws.primary
  }

  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.vpc.vpc_id
  application_port = 80

}



module "ec2" {
  source = "../../modules/ec2"

  providers = {
    aws = aws.primary
  }

  project_name = var.project_name
  environment  = var.environment

  private_subnet_ids = values(module.vpc.private_subnet_ids)

  ec2_security_group_id = module.security_groups.ec2_security_group_id

  instance_profile_name = module.iam.ec2_instance_profile_name
  instance_type         = "t3.micro"
  root_volume_size      = 20
}

module "alb_asg" {

  source = "../../modules/alb-asg"

  providers = {
    aws = aws.primary
  }

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

  providers = {
    aws = aws.primary
  }

  project_name = var.project_name
  environment  = var.environment

  alb_arn_suffix = module.alb_asg.alb_arn_suffix

  autoscaling_group_name = module.alb_asg.autoscaling_group_name

  alert_email = "gireeshkumaryadav2317@gmail.com"
}




# module "fis" {

#   source = "../../modules/fis"

#   providers = {
#     aws = aws.primary
#   }

#   project_name = var.project_name
#   environment  = var.environment

#   fis_role_arn = module.iam.fis_role_arn

#   autoscaling_group_name = module.alb_asg.autoscaling_group_name
# }

# module "route53" {

#   source = "../../modules/route53"

#   project_name = var.project_name
#   environment  = var.environment

#   domain_name = "disaster-recovery.com"

#   alb_dns_name = module.alb_asg.alb_dns_name

#   alb_zone_id = module.alb_asg.alb_zone_id
# }


####################
# DISASTER RECOVERY
####################

module "dr_vpc" {

  source = "../../modules/vpc"

  providers = {
    aws = aws.dr
  }

  project_name = "${var.project_name}-dr"

  environment = var.environment

  cidr_block = "10.1.0.0/16"

  azs = [
    "us-west-2a",
    "us-west-2b"
  ]

  enable_nat_gateway = true

  single_nat_gateway = false
}


module "dr_security_groups" {

  source = "../../modules/security-groups"

  providers = {
    aws = aws.dr
  }

  project_name = "${var.project_name}-dr"

  environment = var.environment

  vpc_id = module.dr_vpc.vpc_id

  application_port = 80
}

############################################
# DR EC2
############################################

module "dr_ec2" {

  source = "../../modules/ec2"

  providers = {
    aws = aws.dr
  }

  project_name = "${var.project_name}-dr"

  environment = var.environment

  private_subnet_ids = values(
    module.dr_vpc.private_subnet_ids
  )

  ec2_security_group_id = module.dr_security_groups.ec2_security_group_id

  instance_profile_name = module.iam.ec2_instance_profile_name

  instance_type = "t3.micro"

  root_volume_size = 20
}

############################################
# DR ALB + ASG
############################################

module "dr_alb_asg" {

  source = "../../modules/alb-asg"

  providers = {
    aws = aws.dr
  }

  project_name = "${var.project_name}-dr"

  environment = var.environment

  vpc_id = module.dr_vpc.vpc_id

  public_subnet_ids = values(
    module.dr_vpc.public_subnet_ids
  )

  private_subnet_ids = values(
    module.dr_vpc.private_subnet_ids
  )

  alb_security_group_id = module.dr_security_groups.alb_security_group_id

  launch_template_id = module.dr_ec2.launch_template_id

  launch_template_version = module.dr_ec2.launch_template_latest_version

  desired_capacity = 2

  min_size = 2

  max_size = 4
}

############################################
# ROUTE53 FAILOVER
############################################

# module "route53" {

#   source = "../../modules/route53"

#   providers = {
#     aws = aws.primary
#   }

#   project_name = var.project_name

#   environment = var.environment

#   domain_name = "disaster-recovery.com"


#   alb_dns_name = module.alb_asg.alb_dns_name

#   alb_zone_id = module.alb_asg.alb_zone_id

#   dr_alb_dns_name = module.dr_alb_asg.alb_dns_name

#   dr_alb_zone_id = module.dr_alb_asg.alb_zone_id
# }