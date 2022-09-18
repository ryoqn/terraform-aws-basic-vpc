output "vpc_id" {
  value = local.vpc_id
}

output "eip" {
  value = aws_eip.this[*]
}

output "vpc_cidr_block" {
  value = local.vpc_cidr_block
}

output "subnet_public_list" {
  value = values(aws_subnet.public)
}

output "subnet_private_list" {
  value = values(aws_subnet.private)
}
