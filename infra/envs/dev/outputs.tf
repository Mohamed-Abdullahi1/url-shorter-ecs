output "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  value       = module.alb.alb_dns_name
}

output "api_blue_target_group_arn" {
  value = module.alb.api_blue_target_group_arn
}

output "api_green_target_group_arn" {
  value = module.alb.api_green_target_group_arn
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "application_url" {
  description = "Application URL"
  value       = module.route53.application_url
}

output "frontend_target_group_arn" {
  description = "Frontend target group ARN"
  value       = module.alb.frontend_target_group_arn
}
