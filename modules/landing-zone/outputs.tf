output "ssm_path" {
  description = "The SSM parameter path prefix for this landing zone"
  value       = "/${lower(var.name)}"
}

output "iam_role_arn" {
  description = "The ARN of the landing zone workload IAM role"
  value       = aws_iam_role.workload.arn
}

output "instance_profile_arn" {
  description = "The ARN of the landing zone workload instance profile"
  value       = aws_iam_instance_profile.workload.arn
}

output "s3_bucket_name" {
  description = "The name of the S3 storage bucket (empty string if enable_s3 is false)"
  value       = var.enable_s3 ? aws_s3_bucket.this[0].id : ""
}
