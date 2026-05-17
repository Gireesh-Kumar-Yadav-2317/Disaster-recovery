variable "region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "project" {
  type = string
}

variable "az_count" {
  type = number
}

variable "enable_nat" {
  type = bool
}

variable "azs" {
  type = list(string)
}