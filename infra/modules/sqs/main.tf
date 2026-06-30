resource "aws_sqs_queue" "click_events" {
  name = "${var.project_name}-click-events"

  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds

  tags = merge(var.tags, {
    Name = "${var.project_name}-click-events"
  })
}
