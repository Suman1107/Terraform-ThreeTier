#-----loadbalancer/output.tf----

output "lb-arn" {
  value = aws_lb.loadbalancer.arn
}

output "target_group_arns" {
  value = aws_lb_target_group.lb-tg.arn
}
