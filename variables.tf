variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "aws_region" {
  description = "VPC Region"
  default     = "ap-south-1"
}

variable "subnet_cidr" {
  description = "Subnet CIDRS"
  type        = list(string)
}
