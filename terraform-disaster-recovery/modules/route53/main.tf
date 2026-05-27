resource "aws_route53_zone" "this" {

  name = var.domain_name

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-zone"
    }
  )
}

resource "aws_route53_health_check" "primary" {

  fqdn = var.alb_dns_name

  port = 80

  type = "HTTP"

  resource_path = "/"

  failure_threshold = 3

  request_interval = 30

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-health-check"
    }
  )
}

resource "aws_route53_record" "primary" {

  zone_id = aws_route53_zone.this.zone_id

  name = var.domain_name

  type = "A"

  set_identifier = "primary"

  failover_routing_policy {
    type = "PRIMARY"
  }

  health_check_id = aws_route53_health_check.primary.id

  alias {

    name = var.alb_dns_name

    zone_id = var.alb_zone_id

    evaluate_target_health = true
  }
}

resource "aws_route53_record" "secondary" {

  zone_id = aws_route53_zone.this.zone_id

  name = var.domain_name

  type = "A"

  set_identifier = "secondary"

  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {

    name = var.dr_alb_dns_name

    zone_id = var.dr_alb_zone_id

    evaluate_target_health = true
  }
}