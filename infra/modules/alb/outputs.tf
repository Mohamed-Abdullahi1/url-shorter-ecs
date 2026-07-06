output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "api_target_group_arn" {
  value = aws_lb_target_group.api.arn
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}
