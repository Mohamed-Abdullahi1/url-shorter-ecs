output "application_url" {
  description = "Application URL"
  value       = "https://${var.domain_name}"
}

output "record_fqdn" {
  description = "Application DNS record"
  value       = aws_route53_record.app.fqdn
}
