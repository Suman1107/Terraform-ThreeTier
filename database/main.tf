#===========root/database.tf============

resource "aws_db_instance" "mysql" {
  identifier             = "mysql-rds"
  storage_type           = var.storage_type
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_subnet_group_name   = var.db_subnet_group_name
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = true
  vpc_security_group_ids = var.rds_sg
  name                   = var.dbname
  username               = var.dbusername
  password               = var.dbpassword

  tags = {
    Name = "mysql"
  }
}
