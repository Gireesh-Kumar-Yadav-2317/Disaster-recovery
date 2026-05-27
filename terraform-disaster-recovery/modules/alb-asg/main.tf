resource "aws_lb" "this" {
    name = "${local.name_prefix}-alb"

    internal = false
    load_balancer_type = "application"

    security_groups = [var.alb_security_group_id]

    subnets = var.public_subnet_ids
    idle_timeout = 60
     

     tags = merge(
        local.common_tags,
        {
            Name = "${local.name_prefix}-alb"
        }
     )
  
}


resource "aws_lb_target_group" "this" {

    name = "${local.name_prefix}-tg"

    port = var.application_port
    protocol = "HTTP"
    vpc_id = var.vpc_id
    target_type = "instance"

    health_check {
      enabled = true

      path = "/"

      healthy_threshold = 3

      unhealthy_threshold = 3

      interval =30

      timeout = 15

      matcher = "200"


    }

    tags = merge(
        local.common_tags,
        {
            Name = "${local.name_prefix}-tg"
        }
    )
}

resource "aws_lb_listener" "http" {

    load_balancer_arn = aws_lb.this.arn

    port = 80

    protocol = "HTTP"

    default_action {
      type = "forward"

      target_group_arn = aws_lb_target_group.this.arn
    }
  
}


resource "aws_autoscaling_group" "this" {

    name = "${local.name_prefix}-asg"

    desired_capacity = var.desired_capacity

    min_size = var.min_size 

    max_size = var.max_size
    vpc_zone_identifier = var.private_subnet_ids
    
    health_check_type = "ELB"

    health_check_grace_period = 300

    target_group_arns = [
        aws_lb_target_group.this.arn
    ]

    launch_template {
      id = var.launch_template_id
      version = var.launch_template_version

    }

    instance_refresh {
      strategy = "Rolling"
      preferences {
        min_healthy_percentage = 50

      }
    }

   dynamic "tag" {

    for_each = merge(
      local.common_tags,
      {
        Name = "${local.name_prefix}-ec2"
      }
    )

    content {

      key = tag.key

      value = tag.value

      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "cpu_target" {

  name = "${local.name_prefix}-cpu-scaling"

  autoscaling_group_name = aws_autoscaling_group.this.name

  policy_type = "TargetTrackingScaling"

  target_tracking_configuration {

    predefined_metric_specification {

      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70
  }
}