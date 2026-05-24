
variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}


variable "vpc_id" {
  type = string
}


variable "alb_ingress_cidrs" {

  description = "Allowed ingress CIDRs for ALB"

  type = list(string)

  default = ["0.0.0.0/0"]
}



variable "application_port" {

  description = "Application port"

  type = number

  default = 80
}