variable "name" {
  description = "Landing zone name, used as a prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "cidr" {
  description = "CIDR block for the landing zone (stored as SSM config, not a real VPC)"
  type        = string
}

variable "region" {
  description = "AWS region for this landing zone"
  type        = string
  default     = "eu-west-1"
}

variable "enable_s3" {
  description = "Controls S3 bucket, bucket policy, IAM policy attachment, and storage SSM parameter"
  type        = bool
  default     = true
}

variable "enable_ssm_advanced" {
  description = "Controls whether SSM parameters use the Advanced tier (larger values, policies)"
  type        = bool
  default     = false
}

variable "extra_tags" {
  description = "Additional tags to merge into all resources — useful for demonstrating in-place updates during a live demo"
  type        = map(string)
  default     = {}
}
