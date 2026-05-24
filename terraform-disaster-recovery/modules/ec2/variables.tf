variable "project_name" {

    type = string
  
}

variable "environment" {
    type = string
  
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "ec2_security_group_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}


variable "instance_type" {

  type = string

  default = "t3.micro"
}

variable "root_volume_size" {

  type = number

  default = 20

}

variable "application_port" {

  type = number

  default = 80
}
