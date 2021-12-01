#-----root/main.tf-----------

module "vpc" {
  source               = "./vpc"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidr   = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  public_subnet_count  = 2
  private_subnet_cidr  = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_subnet_count = 2
  max_az_count         = 5

}

module "security" {
  source         = "./security"
  vpc_id         = module.vpc.vpc_id
  security_group = local.security_group
}

module "compute" {
  source                    = "./compute"
  key_name                  = "ec2-sshkey"
  sshkey_path               = "/home/ubuntu/.ssh/mtckey.pub"
  instance_type             = "t3.micro"
  ebs_volume_size           = 8
  public_sg                 = module.security.public_sg
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_nodes             = 1
  asg_subnet                = module.vpc.public_subnet
  target_group_arns         = [module.loadbalancer.target_group_arns]
  userdata                  = "/home/ubuntu/environment/There-tier/userdata.sh"
}

module "loadbalancer" {
  source              = "./loadbalancer"
  alb_security_groups = [module.security.lb-security_group_id]
  alb_subnets         = module.vpc.public_subnet
  lb_port             = 80
  lb_protocol         = "HTTP"
  lb_vpc_id           = module.vpc.vpc_id
  target_type         = "instance"
  listener_port       = 80
  listener_protocol   = "HTTP"
}

module "database" {
  source = "./database"
  storage_type = "gp2"
  allocated_storage = 20
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.m5.large"
  db_subnet_group_name = module.vpc.db_subnet_group_name[0]
  parameter_group_name = "default.mysql5.7"
  rds_sg = [module.security.db-security_group_id]
  dbname = "rds"
  dbusername = var.dbusername
  dbpassword = var.dbpassword
}
