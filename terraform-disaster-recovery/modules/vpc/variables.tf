variable "cidr_block" {

    description = "CIDR block for the VPC"
    type        = string
  
}


variable "enable_nat_gateway" {
    description = "Whether to create NAT Gateways for private subnets"
    type        = bool
    default     = true
}

variable "azs" {
    description = "List of availability zones to use for subnets"
    type        = list(string)
    default     = []
  
}

variable "enable_dns_support" {
    description = "Whether to enable DNS support in the VPC"
    type        = bool
    default     = true
  
}

variable "enable_dns_hostnames" {
    description = "Whether to enable DNS hostnames in the VPC"
    type        = bool
    default     = true
  
}

variable "project_name" {
    description = "Project name for tagging resources"
    type        = string
}


variable "environment" {
    description = "Environment name for tagging resources"
    type        = string  
}
