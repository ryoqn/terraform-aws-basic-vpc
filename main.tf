locals {
  vpc_id           = var.create_vpc == true ? aws_vpc.this[0].id : var.vpc_id
  vpc_cidr_block   = var.create_vpc == true ? aws_vpc.this[0].cidr_block : var.vpc_cidr_block
  nat_gateway_list = var.create_nat_gateway == true ? var.subnet_public_list : []
}

# ------------------------------------------------------------------------
# VPC
# ------------------------------------------------------------------------
resource "aws_vpc" "this" {
  count = var.create_vpc == true ? 1 : 0

  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = join("-", [var.env, "vpc"])
  }
}

# ------------------------------------------------------------------------
# Internet Gateway
# ------------------------------------------------------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = local.vpc_id

  tags = {
    Name = join("-", [var.env, "igw"])
  }
}

# ------------------------------------------------------------------------
# Elastic Ips
# ------------------------------------------------------------------------
resource "aws_eip" "this" {
  for_each = { for i in local.nat_gateway_list : i.az => i }

  vpc        = true
  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = join("-", [
      var.env, "eip", index(local.nat_gateway_list, { az = each.value.az, cidr = each.value.cidr }) + 1
    ])
  }
}

# ------------------------------------------------------------------------
# NAT Gateway
# ------------------------------------------------------------------------
resource "aws_nat_gateway" "this" {
  for_each = { for i in local.nat_gateway_list : i.az => i }

  depends_on    = [aws_internet_gateway.this]
  allocation_id = aws_eip.this[each.value.az].id
  subnet_id     = aws_subnet.public[each.value.az].id

  tags = {
    Name = join("-", [
      var.env, "ngw", index(local.nat_gateway_list, { az = each.value.az, cidr = each.value.cidr }) + 1
    ])
  }
}
