variable "hosted_zone_id" {
  description = "Existing Route 53 hosted zone ID"
  type        = string
}

variable "domain_name" {
  description = "Application domain name"
  type        = string
}

variable "alb_dns_name" {
  description = "Application Load Balancer DNS name"
  type        = string
}

variable "alb_zone_id" {
  description = "Application Load Balancer hosted zone ID"
  type        = string
}
