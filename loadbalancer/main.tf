#-----loadbalancer/main.tf ----

resource "aws_lb" "loadbalancer" {
  name                             = "loadbalancer"
  internal                         = false
  load_balancer_type               = "application"
  security_groups                  = var.alb_security_groups
  subnets                          = var.alb_subnets
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  tags = {
    Name = "Application Loadbalancer"
  }
}

#---Target Group---

resource "aws_lb_target_group" "lb-tg" {
  name        = "lb-target-group"
  port        = var.lb_port
  protocol    = var.lb_protocol
  vpc_id      = var.lb_vpc_id
  target_type = var.target_type
  lifecycle {
    create_before_destroy = true
  }
  health_check {
    interval            = 10
    path                = "/"
    protocol            = var.lb_protocol
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

#--- LB listener ---

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn
  }
  depends_on = [aws_lb_target_group.lb-tg]
}
