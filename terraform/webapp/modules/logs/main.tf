resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/ecs/${var.application_name}-${var.environment}"
  retention_in_days = 14
  tags              = var.tags
}