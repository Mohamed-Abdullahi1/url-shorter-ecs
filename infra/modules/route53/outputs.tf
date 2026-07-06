output "hosted_zone_id" {
  description = "Hosted Zone ID"
  value       = aws_route53_zone.zone.zone_id
}

output "name_servers" {
  description = "Route53 name servers"
  value       = aws_route53_zone.zone.name_servers
}

output "application_url" {
  description = "Application URL"
  value       = "https://${var.domain_name}"
}
