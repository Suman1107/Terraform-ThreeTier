#----- loadbalancer/variable.tf----

variable "alb_security_groups" {
  type = list(string)
}

variable "alb_subnets" {}

variable "lb_port" {
  type = number
}

variable "lb_protocol" {
  type = string
}

variable "lb_vpc_id" {
  type = string
}

variable "target_type" {
  type = string
}

variable "listener_port" {
  type = number
}

variable "listener_protocol" {
  type = string
}
