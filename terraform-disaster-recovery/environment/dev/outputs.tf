############################################
# PRIMARY REGION — VPC
############################################

output "vpc_id" {

  description = "Primary VPC ID"

  value = module.vpc.vpc_id
}

output "public_subnet_ids" {

  description = "Primary public subnet IDs"

  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {

  description = "Primary private subnet IDs"

  value = module.vpc.private_subnet_ids
}

############################################
# PRIMARY REGION — ALB
############################################

output "primary_alb_dns_name" {

  description = "Primary ALB DNS name"

  value = module.alb_asg.alb_dns_name
}

output "primary_alb_arn" {

  description = "Primary ALB ARN"

  value = module.alb_asg.alb_arn
}

output "primary_target_group_arn" {

  description = "Primary target group ARN"

  value = module.alb_asg.target_group_arn
}

############################################
# PRIMARY REGION — ASG
############################################

output "primary_autoscaling_group_name" {

  description = "Primary Auto Scaling Group"

  value = module.alb_asg.autoscaling_group_name
}

############################################
# PRIMARY REGION — EC2
############################################

output "primary_launch_template_id" {

  description = "Primary launch template ID"

  value = module.ec2.launch_template_id
}

############################################
# IAM
############################################

output "ec2_instance_profile_name" {

  description = "EC2 instance profile"

  value = module.iam.ec2_instance_profile_name
}

output "fis_role_arn" {

  description = "FIS IAM role ARN"

  value = module.iam.fis_role_arn
}

############################################
# MONITORING
############################################

output "cpu_alarm_name" {

  description = "CPU CloudWatch alarm"

  value = module.monitoring.cpu_alarm_name
}

output "alb_alarm_name" {

  description = "ALB unhealthy host alarm"

  value = module.monitoring.alb_alarm_name
}

############################################
# FIS
############################################

# output "fis_experiment_template_id" {

#   description = "Primary FIS experiment template"

#   value = module.fis.fis_experiment_template_id
# }

# output "cpu_stress_experiment_id" {

#   description = "CPU stress FIS experiment"

#   value = module.fis.cpu_stress_experiment_id
# }

# output "network_latency_experiment_id" {

#   description = "Network latency experiment"

#   value = module.fis.network_latency_experiment_id
# }

# output "multi_instance_stop_experiment_id" {

#   description = "Multi-instance stop experiment"

#   value = module.fis.multi_instance_stop_experiment_id
# }

#################################################
# DR REGION — VPC
#################################################

output "dr_vpc_id" {

  description = "DR VPC ID"

  value = module.dr_vpc.vpc_id
}

output "dr_public_subnet_ids" {

  description = "DR public subnet IDs"

  value = module.dr_vpc.public_subnet_ids
}

output "dr_private_subnet_ids" {

  description = "DR private subnet IDs"

  value = module.dr_vpc.private_subnet_ids
}

#################################################
# DR REGION — ALB
#################################################

output "dr_alb_dns_name" {

  description = "DR ALB DNS"

  value = module.dr_alb_asg.alb_dns_name
}

output "dr_alb_arn" {

  description = "DR ALB ARN"

  value = module.dr_alb_asg.alb_arn
}

#################################################
# DR REGION — ASG
#################################################

output "dr_autoscaling_group_name" {

  description = "DR Auto Scaling Group"

  value = module.dr_alb_asg.autoscaling_group_name
}

#################################################
# DR REGION — EC2
#################################################

output "dr_launch_template_id" {

  description = "DR launch template ID"

  value = module.dr_ec2.launch_template_id
}