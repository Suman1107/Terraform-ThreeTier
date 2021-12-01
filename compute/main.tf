#----compute/main.tf-----

#----this is data resource for all the available ami in AWS ----

data "aws_ami" "all_available_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

#---this resource generated random ID to make EC2 instnces unique ---

resource "random_id" "asg-random_id" {
  byte_length = 1
  count       = var.max_size
  keepers = {
    key_name  = var.key_name
    user_data = var.userdata
  }
}

#----- this holds the keypair to login to EC2 instances----

resource "aws_key_pair" "ec2-keypair" {
  key_name   = var.key_name
  public_key = file(var.sshkey_path)
}

#---instance template for AG -------

resource "aws_launch_template" "ec2-launch-template" {
  name                   = "autoscaling-launch-template"
  image_id               = data.aws_ami.all_available_ami.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2-keypair.id
  vpc_security_group_ids = [var.public_sg]

  tags = {
    Name = "aws-ec2-launch-template"
  }

  user_data = filebase64(var.userdata)

  lifecycle {
    create_before_destroy = true
  }
}

#---Autoscaling group ----

resource "aws_autoscaling_group" "frontend" {
  name                      = "frontend-asg"
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_nodes
  force_delete              = true
  vpc_zone_identifier       = var.asg_subnet
  target_group_arns         = var.target_group_arns

  launch_template {
    id      = aws_launch_template.ec2-launch-template.id
    version = "$Latest"
  }
  #-- Automatically refresh all instances after the group is updated--
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
  tags = [{
    "key"                 = "Name"
    "value"               = "asg-instances"
    "propagate_at_launch" = true
  }]

  #  depends_on = [module.loadbalancer.aws_lb_target_group]
}

