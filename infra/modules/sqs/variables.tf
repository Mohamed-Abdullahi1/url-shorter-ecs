variable "project_name" {
  description = "Project name used to prefix the SQS queue"
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "How long a message stays invisible after being received"
  type        = number
  default     = 30
}

variable "message_retention_seconds" {
  description = "How long messages are kept in the queue"
  type        = number
  default     = 345600
}

variable "tags" {
  description = "Tags applied to the SQS queue"
  type        = map(string)
  default     = {}
}
