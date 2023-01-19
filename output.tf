output "admin_username" {
  description = "AmazonMQ admin username"
  value       = var.user_adm
}

output "broker_id" {
  description = "AmazonMQ broker ID"
  value       = aws_mq_broker.create_aws_mq.id
}

output "broker_arn" {
  description = "AmazonMQ broker ARN"
  value       = aws_mq_broker.create_aws_mq.arn
}

output "instances" {
  description = "AmazonMQ information intances"
  value       = aws_mq_broker.create_aws_mq.instances
}

output "primary_console_url" {
  description = "AmazonMQ active web console URL"
  value       = aws_mq_broker.create_aws_mq.instances[*].console_url
}

output "primary_ssl_endpoint" {
  description = "Console URL and endpoints"
  value       = aws_mq_broker.create_aws_mq.instances[*].endpoints
}

output "primary_ip_address" {
  description = "AmazonMQ primary IP address"
  value       = aws_mq_broker.create_aws_mq.instances[*].ip_address
}

output "storage_type" {
  description = "AmazonMQ storage type"
  value       = aws_mq_broker.create_aws_mq.storage_type
}

output "maintenance_window" {
  description = "AmazonMQ maintenance window start time"
  value       = aws_mq_broker.create_aws_mq.maintenance_window_start_time
}
