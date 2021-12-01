#------root/variable.tf------

variable "ssh_access_ip" {
  type = list(any)
}

variable "http_access_ip" {
  type = list(any)
}

variable "dbusername" {
  type = string
  description = "rds username"
}

variable "dbpassword" {
  type = string
  description = "rds password"
}
