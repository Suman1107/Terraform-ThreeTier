#===============security/main.tf===============

#------instances security group-------------

resource "aws_security_group" "sg-vpc" {
  for_each    = var.security_group
  name        = "vpc-sg"
  description = "my_vpc-sg"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks

    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#------loadbalancer security group-------------

resource "aws_security_group" "lb_sg-vpc" {
  name        = "lb-sg"
  description = "loadbalancer-security-group"
  vpc_id      = var.vpc_id
  ingress {
    description = "inbound-rule-sg"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outbound-rule-sg"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#-----------RDS security group------------------

resource "aws_security_group" "db-security_group" {
  name        = "db-sg"
  description = "rds security_group"
  vpc_id      = var.vpc_id
  ingress {
    description     = "inbound access from app layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.sg-vpc["incoming"].id]
  }

  egress {
    description = "outbound access from app layer"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_security_group.sg-vpc]
}
