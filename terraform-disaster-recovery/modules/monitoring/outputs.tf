
output "sns_topic_arn" {

  value = aws_sns_topic.alerts.arn
}

output "cpu_alarm_name" {

  value = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}

output "alb_alarm_name" {

  value = aws_cloudwatch_metric_alarm.alb_unhealthy_hosts.alarm_name
}

output "asg_alarm_name" {

  value = aws_cloudwatch_metric_alarm.asg_instances.alarm_name
}
output "alb_arn_suffix" {
  description = "ALB ARN suffix passed from alb_asg"
  value       = var.alb_arn_suffix
}

