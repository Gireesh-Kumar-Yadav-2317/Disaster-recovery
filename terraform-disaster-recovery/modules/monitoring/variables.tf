
variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}


variable "alert_email" {
  type = string
}
variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB"
  type        = string
}

variable "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}
