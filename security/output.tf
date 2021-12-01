#-------security/output.tf----------


output "public_sg" {
  value = aws_security_group.sg-vpc["incoming"].id
}

output "lb-security_group_id" {
  value = aws_security_group.lb_sg-vpc.id
}

output "db-security_group_id" {
  value = aws_security_group.db-security_group.id
}
