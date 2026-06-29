variable "project_name" {
  description = "Project name used as a prefix for repository names"
  type        = string
}

variable "repository_names" {
  description = "List of service names to create repositories for"
  type        = list(string)
  default     = ["api", "worker", "dashboard"]
}

variable "untagged_image_retention_days" {
  description = "Number of days to retain untagged images before expiry"
  type        = number
  default     = 1
}

variable "tagged_image_count" {
  description = "Maximum number of tagged images to retain per repository"
  type        = number
  default     = 10
}

variable "tags" {
  description = "Tags to apply to all ECR repositories"
  type        = map(string)
  default     = {}
}
