variable "name" {
  type        = string
  description = "Landing zone name, used as a prefix for all resources"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. dev, test, prod)"
  default     = "dev"
}

variable "cidr" {
  type        = string
  description = "CIDR block for the landing zone (stored as SSM config)"
}

variable "region" {
  type        = string
  description = "AWS region for this landing zone"
  default     = "eu-west-1"
}

variable "enable_s3" {
  type        = bool
  description = "Controls S3 bucket, bucket policy, IAM policy attachment, and storage SSM parameter"
  default     = true
}

variable "enable_ssm_advanced" {
  type        = bool
  description = "Controls whether SSM parameters use the Advanced tier"
  default     = false
}

variable "extra_tags" {
  type        = map(string)
  description = "Additional tags to merge into all resources"
  default     = {}
}
