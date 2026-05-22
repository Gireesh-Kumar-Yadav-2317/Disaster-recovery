

variable "project_name" {

  description = "Project name used for resource naming"

  type = string

  validation {
    condition = length(var.project_name) > 2
    error_message = "Project name must contain at least 3 characters."
  }

  validation {
    condition = can(regex("^[a-zA-Z0-9-]+$", var.project_name))
    error_message = "Project name can contain only letters, numbers, and hyphens."
  }
}


variable "environment" {

  description = "Deployment environment"

  type = string

  validation {
    condition = contains(
      ["dev", "qa", "stage", "prod"],
      var.environment
    )

    error_message = "Environment must be one of: dev, qa, stage, prod."
  }
}

variable "cidr_block" {

  description = "VPC CIDR block"

  type = string

  validation {
    condition = can(cidrhost(var.cidr_block, 0))
    error_message = "Invalid VPC CIDR block."
  }
}

variable "azs" {

  description = "Availability Zones"

  type = list(string)

  validation {
    condition = length(var.azs) >= 2
    error_message = "At least 2 Availability Zones are required for high availability."
  }
}

variable "enable_dns_support" {

  description = "Enable DNS support in VPC"

  type = bool

  default = true
}


variable "enable_dns_hostnames" {

  description = "Enable DNS hostnames in VPC"

  type = bool

  default = true
}


variable "enable_nat_gateway" {

  description = "Enable NAT Gateway"

  type = bool

  default = true
}


variable "single_nat_gateway" {

  description = "Use single NAT Gateway to reduce cost"

  type = bool

  default = false
}