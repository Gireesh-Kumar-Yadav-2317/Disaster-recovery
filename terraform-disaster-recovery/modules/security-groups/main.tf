resource "aws_security_group" "alb" {
    name = "${local.name_prefix}-alb-sg"

    vpc_id = var.vpc_id

    tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alb-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_vpc_security_group_ingress_rule" "alb_http" {

    security_group_id = aws_security_group.alb.id
    description = "Allow HTTP traffic"
    from_port = 80
    to_port = 80

    ip_protocol = "tcp"
    cidr_ipv4 = "0.0.0.0/0"


}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {

  security_group_id = aws_security_group.alb.id

  description = "Allow HTTPS traffic"

  from_port = 443
  to_port   = 443

  ip_protocol = "tcp"

  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_outbound" {

  security_group_id = aws_security_group.alb.id

  description = "Allow outbound traffic"

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_security_group" "ec2" {

  name = "${local.name_prefix}-ec2-sg"

  description = "Security group for EC2 instances"

  vpc_id = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ec2-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_vpc_security_group_ingress_rule" "ec2_from_alb" {

  security_group_id = aws_security_group.ec2.id

  referenced_security_group_id = aws_security_group.alb.id

  from_port = var.application_port
  to_port   = var.application_port

  ip_protocol = "tcp"

  description = "Allow traffic from ALB only"
}

resource "aws_vpc_security_group_egress_rule" "ec2_outbound" {

  security_group_id = aws_security_group.ec2.id

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"

  description = "Allow outbound internet access"
}


resource "aws_vpc_security_group_ingress_rule" "ec2_internal" {

  security_group_id = aws_security_group.ec2.id

  referenced_security_group_id = aws_security_group.ec2.id

  ip_protocol = "-1"

  description = "Allow internal EC2 communication"
}