resource "aws_route53_zone" "zone" {
  name = var.domain_name

  tags = merge(var.tags, {
    Name = var.domain_name
  })
}

resource "aws_route53_record" "certificate_validation" {
  for_each = {
    for dvo in var.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.zone.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn = var.certificate_arn
  validation_record_fqdns = [
    for record in aws_route53_record.certificate_validation : record.fqdn
  ]
}

resource "aws_route53_record" "alb_alias" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }

  depends_on = [
    aws_acm_certificate_validation.certificate
  ]
}
