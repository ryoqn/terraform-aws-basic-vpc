# ------------------------------------------------------------------------
# public
# ------------------------------------------------------------------------
resource "aws_subnet" "public" {

  for_each = { for i in var.subnet_public_list : i.az => i }

  vpc_id = local.vpc_id

  availability_zone = each.value.az

  map_public_ip_on_launch = true

  cidr_block = each.value.cidr

  tags = {
    Name = join("-", [
      var.env, "public",
      trimprefix(each.value.az, "ap-northeast-1")
    ])
  }
}

# ------------------------------------------------------------------------
# private
# ------------------------------------------------------------------------
resource "aws_subnet" "private" {

  for_each = { for i in var.subnet_private_list : i.az => i }

  vpc_id = local.vpc_id

  availability_zone = each.value.az

  map_public_ip_on_launch = false

  cidr_block = each.value.cidr

  tags = {
    Name = join("-", [
      var.env, "private",
      trimprefix(each.value.az, "ap-northeast-1")
    ])
  }
}
