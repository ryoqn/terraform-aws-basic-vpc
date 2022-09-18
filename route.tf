# ------------------------------------------------------------------------
# public
# ------------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  tags = {
    Name = join("-", [var.env, "public"])
  }
}
# to igw
resource "aws_route" "public-igw" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
  route_table_id         = aws_route_table.public.id
}
# attach public subnet
resource "aws_route_table_association" "public" {
  for_each = { for i in var.subnet_public_list : i.az => i }

  subnet_id      = aws_subnet.public[each.value.az].id
  route_table_id = aws_route_table.public.id
}

# ------------------------------------------------------------------------
# private
# ------------------------------------------------------------------------
resource "aws_route_table" "private" {
  for_each = { for i in var.subnet_private_list : i.az => i }

  vpc_id = local.vpc_id

  tags = {
    Name = join("-", [var.env, "private", trimprefix(each.value.az, "ap-northeast-1")])
  }
}
# to nat
# TODO NATを作るか作らないかで判断
resource "aws_route" "nat-private" {
  for_each = { for i in local.nat_gateway_list : i.az => i }

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[each.value.az].id
  route_table_id         = aws_route_table.private[each.value.az].id
}
# attach subnet
resource "aws_route_table_association" "private" {
  for_each = { for i in var.subnet_private_list : i.az => i }

  subnet_id      = aws_subnet.private[each.value.az].id
  route_table_id = aws_route_table.private[each.value.az].id
}
