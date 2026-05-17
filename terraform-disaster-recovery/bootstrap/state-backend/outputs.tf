output "state_bucket_name" {
  description = "Terraform state bucket name"
  value       = aws_s3_bucket.state_backend.bucket
}

output "state_bucket_arn" {
  description = "Terraform state bucket ARN"
  value       = aws_s3_bucket.state_backend.arn
}

output "dynamodb_table_name" {
  description = "Terraform lock table name"
  value       = aws_dynamodb_table.state_lock.name
}

output "dynamodb_table_arn" {
  description = "Terraform lock table ARN"
  value       = aws_dynamodb_table.state_lock.arn
}