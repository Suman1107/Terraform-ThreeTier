#---- vpc/output.tf---

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet.*.id
}

output "private_subnet" {
  value = aws_subnet.private_subnet.*.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.rds_subnet_group.*.name
}
