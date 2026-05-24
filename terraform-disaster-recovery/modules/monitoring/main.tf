resource "aws_sns_topic" "alerts" {

  name = "${local.name_prefix}-alerts"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-alerts"
    }
  )
}

resource "aws_sns_topic_subscription" "email" {

  topic_arn = aws_sns_topic.alerts.arn

  protocol = "email"

  endpoint = var.alert_email
}


resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name = "${local.name_prefix}-high-cpu"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 300

  statistic = "Average"

  threshold = 80

  alarm_description = "High CPU utilization detected"

  treat_missing_data = "notBreaching"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  tags = local.common_tags
}


resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {

  alarm_name = "${local.name_prefix}-alb-unhealthy-hosts"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 1

  metric_name = "UnHealthyHostCount"

  namespace = "AWS/ApplicationELB"

  period = 60

  statistic = "Average"

  threshold = 1

  alarm_description = "ALB unhealthy host detected"

  treat_missing_data = "notBreaching"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = local.common_tags
}


resource "aws_cloudwatch_metric_alarm" "asg_instances" {

  alarm_name = "${local.name_prefix}-asg-instance-count"

  comparison_operator = "LessThanThreshold"

  evaluation_periods = 1

  metric_name = "GroupInServiceInstances"

  namespace = "AWS/AutoScaling"

  period = 60

  statistic = "Average"

  threshold = 1

  alarm_description = "ASG instance count too low"

  treat_missing_data = "breaching"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]

  dimensions = {
    AutoScalingGroupName = var.autoscaling_group_name
  }

  tags = local.common_tags
}