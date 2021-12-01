
#=========database/variable.tf==============

variable "storage_type" {
  type        = string
  description = "db storage type - gp2"
}

variable "allocated_storage" {
  type        = number
  description = "db storage space - 20G"
}

variable "engine" {
  type        = string
  description = "db type - mysql"
}

variable "engine_version" {
  type        = string
  description = "mysql version - 5.7"
}

variable "instance_class" {
  type        = string
  description = "mysql instance type - db.t2.micro"
}

variable "db_subnet_group_name" {
#  type        = list(string)
  description = "private subnets for RDS - from vpc"
}

variable "parameter_group_name" {
  type        = string
  description = "parameter_group_name - default.mysql5.7"
}

variable "rds_sg" {
  type        = list(string)
  description = "security groups for RDS - from security"
}

variable "dbname" {
  type        = string
  description = "database name"
}

variable "dbusername" {
  type        = string
  description = "database username"
}

variable "dbpassword" {
  type        = string
  description = "database password"
}


