#------compute/variable.tf------

variable "key_name" {
  type = string
}
variable "sshkey_path" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ebs_volume_size" {
  type = number
}

variable "public_sg" {}

variable "userdata" {}

#== variable for autoscaling group ==

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "health_check_grace_period" {
  type = number
}

variable "health_check_type" {
  type = string
}

variable "desired_nodes" {
  type = number
}

variable "asg_subnet" {

}

variable "target_group_arns" {
  type = list(string)
}
