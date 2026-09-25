output "ssm_path" {
  type        = string
  description = "The SSM parameter path prefix for this landing zone"
  value       = component.landing_zone.ssm_path
}

output "iam_role_arn" {
  type        = string
  description = "The ARN of the landing zone workload IAM role"
  value       = component.landing_zone.iam_role_arn
}

output "instance_profile_arn" {
  type        = string
  description = "The ARN of the landing zone workload instance profile"
  value       = component.landing_zone.instance_profile_arn
}

output "s3_bucket_name" {
  type        = string
  description = "The name of the S3 storage bucket"
  value       = component.landing_zone.s3_bucket_name
}
