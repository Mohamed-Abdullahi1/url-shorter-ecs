output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "api_blue_target_group_arn" {
  value = aws_lb_target_group.api_blue.arn
}

output "api_green_target_group_arn" {
  value = aws_lb_target_group.api_green.arn
}

output "api_listener_rule_arn" {
  value = aws_lb_listener_rule.api.arn
}

output "api_5xx_alarm_name" {
  value = aws_cloudwatch_metric_alarm.api_5xx.alarm_name
}

output "api_unhealthy_hosts_alarm_name" {
  value = aws_cloudwatch_metric_alarm.api_unhealthy_hosts.alarm_name
}
