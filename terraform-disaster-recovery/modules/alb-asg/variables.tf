variable "project_name" {
    type = string
}

variable "vpc_id" {
    type = string
  
}

variable "environment" {
    type = string
  
}

variable "public_subnet_ids" {
    type = list(string)
  
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {

    type = string
  
}

variable "application_port" {

    type = number
    default = 80
}

variable "desired_capacity" {

    type = number
    default = 2
  
}
variable "min_size" {
    type = number
    default = 2
}

variable "max_size" {
    type = number
  
    default = 4
}

variable "launch_template_id" {
    type = string
}

variable "launch_template_version" {
    type = number
  
}

