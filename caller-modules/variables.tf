variable "environment" {
  description = "Deployment Environment"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(any)
  description = "CIDR block for Private Subnet"
}

variable "availability_zones" {
  type        = list(any)
  description = "AZ in which all the resources will be deployed"
}
variable "region" {
  default = "eu-west-1"
}
variable "ami_id" {
  description = "Ami id which will be used to launch instances"
}
variable "instance_type" {
  description = "Instance type which will be used to launch instances"
}
