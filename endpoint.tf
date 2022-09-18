# ------------------------------------------------------------------------
# VPC Endpoint
# ------------------------------------------------------------------------
# CloudWatch Logs
resource "aws_vpc_endpoint" "cloudwatchlogs" {
  count = var.create_endpoint_cloudwatch_logs == true ? 1 : 0

  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.ap-northeast-1.logs"
  vpc_id            = local.vpc_id

  private_dns_enabled = true
  security_group_ids  = tolist([aws_security_group.endpoint-logs[count.index].id])
  subnet_ids          = values(aws_subnet.private)[*].id

  tags = {
    Name = join("-", [var.env, "cloudwatchlogs"])
  }
}

# DynamoDB
resource "aws_vpc_endpoint" "dynamodb" {
  service_name = "com.amazonaws.ap-northeast-1.dynamodb"
  vpc_id       = local.vpc_id

  route_table_ids = concat(values(aws_route_table.private)[*].id)

  tags = {
    Name = join("-", [var.env, "dynamodb"])
  }
}

# Kinesis Stream
resource "aws_vpc_endpoint" "kinesis" {
  count = var.create_endpoint_kinesis == true ? 1 : 0

  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.ap-northeast-1.kinesis-streams"
  vpc_id            = local.vpc_id

  private_dns_enabled = true
  subnet_ids          = values(aws_subnet.private)[*].id
  security_group_ids  = tolist([aws_security_group.endpoint-kinesis[count.index].id])

  tags = {
    Name = join("-", [var.env, "kinesis"])
  }
}

# S3
resource "aws_vpc_endpoint" "s3" {
  service_name = "com.amazonaws.ap-northeast-1.s3"

  vpc_id          = local.vpc_id
  route_table_ids = concat(values(aws_route_table.private)[*].id)
  tags = {
    Name = join("-", [var.env, "s3"])
  }
}

# ssm
resource "aws_vpc_endpoint" "ssm" {
  count = var.create_endpoint_ssm == true ? 1 : 0

  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.ap-northeast-1.ssm"
  vpc_id            = local.vpc_id

  security_group_ids  = [aws_security_group.endpoint-ssm[count.index].id]
  subnet_ids          = values(aws_subnet.private)[*].id
  private_dns_enabled = true

  tags = {
    Name = join("-", [var.env, "ssm"])
  }
}

# ssmmessages
resource "aws_vpc_endpoint" "ssmmessages" {
  count = var.create_endpoint_ssm == true ? 1 : 0

  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.ap-northeast-1.ssmmessages"
  vpc_id            = local.vpc_id

  security_group_ids  = [aws_security_group.endpoint-ssm[count.index].id]
  subnet_ids          = values(aws_subnet.private)[*].id
  private_dns_enabled = true

  tags = {
    Name = join("-", [var.env, "ssmmessages"])
  }
}

# ec2messages
resource "aws_vpc_endpoint" "ec2messages" {
  count = var.create_endpoint_ssm == true ? 1 : 0

  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.ap-northeast-1.ec2messages"
  vpc_id            = local.vpc_id

  security_group_ids  = [aws_security_group.endpoint-ssm[count.index].id]
  subnet_ids          = values(aws_subnet.private)[*].id
  private_dns_enabled = true

  tags = {
    Name = join("-", [var.env, "ec2messages"])
  }
}

# codedeploy
resource "aws_vpc_endpoint" "codedeploy" {
  count = var.create_endpoint_codedeploy == true ? 1 : 0

  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.ap-northeast-1.codedeploy"
  vpc_id            = local.vpc_id

  security_group_ids  = [aws_security_group.endpoint-codedeploy[count.index].id]
  subnet_ids          = values(aws_subnet.private)[*].id
  private_dns_enabled = true

  tags = {
    Name = join("-", [var.env, "codedeploy"])
  }
}

resource "aws_vpc_endpoint" "codedeploy-commands-secure" {
  count = var.create_endpoint_codedeploy == true ? 1 : 0

  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.ap-northeast-1.codedeploy-commands-secure"
  vpc_id            = local.vpc_id

  security_group_ids  = [aws_security_group.endpoint-codedeploy[count.index].id]
  subnet_ids          = values(aws_subnet.private)[*].id
  private_dns_enabled = true

  tags = {
    Name = join("-", [var.env, "codedeploy-commands-secure"])
  }
}

resource "aws_vpc_endpoint" "sns" {
  count = var.create_endpoint_sns == true ? 1 : 0

  vpc_endpoint_type = "Interface"
  service_name      = "com.amazonaws.ap-northeast-1.sns"
  vpc_id            = local.vpc_id

  security_group_ids  = [aws_security_group.endpoint-sns[count.index].id]
  subnet_ids          = values(aws_subnet.private)[*].id
  private_dns_enabled = true

  tags = {
    Name = join("-", [var.env, "sns"])
  }
}


# ------------------------------------------------------------------------
# Security Group: For VPC Endpoint
# ------------------------------------------------------------------------
# Kinesis
resource "aws_security_group" "endpoint-kinesis" {
  count = var.create_endpoint_kinesis == true ? 1 : 0

  name   = join("-", [var.env, "endpoint-kinesis"])
  vpc_id = local.vpc_id

  tags = {
    Name = join("-", [var.env, "endpoint-kinesis"])
  }
}

resource "aws_security_group_rule" "endpoint-kinesis" {
  count = var.create_endpoint_kinesis == true ? 1 : 0

  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.endpoint-kinesis[count.index].id
  cidr_blocks       = tolist([var.vpc_cidr_block])
}

resource "aws_security_group_rule" "endpoint-kinesis-egress" {
  count = var.create_endpoint_kinesis == true ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.endpoint-kinesis[count.index].id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

# CloudWatch Logs
resource "aws_security_group" "endpoint-logs" {
  count = var.create_endpoint_cloudwatch_logs == true ? 1 : 0

  name   = join("-", [var.env, "endpoint-logs"])
  vpc_id = local.vpc_id

  tags = {
    Name = join("-", [var.env, "endpoint-logs"])
  }
}

resource "aws_security_group_rule" "endpoint-logs" {
  count = var.create_endpoint_cloudwatch_logs == true ? 1 : 0

  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.endpoint-logs[count.index].id
  cidr_blocks       = tolist([var.vpc_cidr_block])
}

resource "aws_security_group_rule" "endpoint-logs-egress" {
  count = var.create_endpoint_cloudwatch_logs == true ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.endpoint-logs[count.index].id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

# SSM
resource "aws_security_group" "endpoint-ssm" {
  count = var.create_endpoint_ssm == true ? 1 : 0

  name   = join("-", [var.env, "endpoint-ssm"])
  vpc_id = local.vpc_id

  tags = {
    Name = join("-", [var.env, "endpoint-ssm"])
  }
}

resource "aws_security_group_rule" "endpoint-ssm" {
  count = var.create_endpoint_ssm == true ? 1 : 0

  security_group_id = aws_security_group.endpoint-ssm[count.index].id
  type              = "ingress"
  cidr_blocks       = [var.vpc_cidr_block]
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
}

# CodeDeploy
resource "aws_security_group" "endpoint-codedeploy" {
  count = var.create_endpoint_codedeploy == true ? 1 : 0

  name   = join("-", [var.env, "endpoint-codedeploy"])
  vpc_id = local.vpc_id

  tags = {
    Name = join("-", [var.env, "endpoint-codedeploy"])
  }
}

resource "aws_security_group_rule" "endpoint-codedeploy-ingress" {
  count = var.create_endpoint_codedeploy == true ? 1 : 0

  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.endpoint-codedeploy[count.index].id
  cidr_blocks       = tolist([var.vpc_cidr_block])
}

resource "aws_security_group_rule" "endpoint-codedeploy-egress" {
  count = var.create_endpoint_codedeploy == true ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.endpoint-codedeploy[count.index].id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
}

# SNS
resource "aws_security_group" "endpoint-sns" {
  count = var.create_endpoint_sns == true ? 1 : 0

  name   = join("-", [var.env, "endpoint-sns"])
  vpc_id = local.vpc_id

  tags = {
    Name = join("-", [var.env, "endpoint-sns"])
  }
}

resource "aws_security_group_rule" "endpoint-sns-ingress" {
  count = var.create_endpoint_sns == true ? 1 : 0

  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.endpoint-sns[count.index].id
  cidr_blocks       = tolist([var.vpc_cidr_block])
}

resource "aws_security_group_rule" "endpoint-sns-egress" {
  count = var.create_endpoint_sns == true ? 1 : 0

  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.endpoint-sns[count.index].id
  cidr_blocks = [
    "0.0.0.0/0",
  ]
}
