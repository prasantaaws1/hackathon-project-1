variable "vpc_cidr" {
  description = "VPC CIDR Range"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet CIDRS"
  type        = list(string)
}

variable "subnet_names" {
  description = "Subnet names"
  type        = list(string)
  default     = ["PublicSubnet1", "PublicSubnet2"]
}

variable "az_count" {
  description = "Number of availability zones"
}
