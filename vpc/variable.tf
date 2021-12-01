#------vpc/variable.tf------

variable "cidr_block" {
  type = string
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "private_subnet_count" {
  type = number
}

variable "max_az_count" {
  type = number
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "public_subnet_count" {
  type = number
}
