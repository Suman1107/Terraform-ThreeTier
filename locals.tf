#------root/locals.tf----

locals {
  vpc_cidr = "10.0.0.0/16"
}

#----locals for security_group----

#=======instances security group==========

locals {
  security_group = {
    incoming = {
      name        = "public-security_group"
      description = "http & ssh access"
      ingress = {
        ssh = {
          description = "ssh access"
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = var.ssh_access_ip
        }
        http = {
          description = "http access"
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = var.http_access_ip
        }
      }
    }
  }
}
