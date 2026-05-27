variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "azs" {
  type = list(string)
}


variable "primary_region" {
  type = string
}

variable "dr_region" {
  type = string
}


variable "dr_cidr_block" {
  type = string
}

variable "dr_azs" {
  type = list(string)
}