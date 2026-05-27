

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain_name" {
  type = string
}

############################################
# ALB
############################################

variable "alb_dns_name" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "dr_alb_dns_name" {
  type = string
}

variable "dr_alb_zone_id" {
  type = string
}