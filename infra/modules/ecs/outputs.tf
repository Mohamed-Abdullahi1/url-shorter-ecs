output "cluster_id" {
  value = aws_ecs_cluster.ecs.id
}

output "cluster_name" {
  value = aws_ecs_cluster.ecs.name
}

output "task_execution_role_arn" {
  value = aws_iam_role.task_execution.arn
}

output "task_role_arn" {
  value = aws_iam_role.task.arn
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs.name
}
