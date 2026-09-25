locals {
  ssm_tier = var.enable_ssm_advanced ? "Advanced" : "Standard"
  ssm_path = "/${lower(var.name)}"

  common_tags = merge(
    {
      Name        = lower(var.name)
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.extra_tags
  )
}

# -----------------------------------------------------------------------------
# SSM Parameter Store: Landing Zone Configuration
# Parameters reference IAM and S3 outputs, creating a real dependency graph
# -----------------------------------------------------------------------------

resource "aws_ssm_parameter" "config_environment" {
  name  = "${local.ssm_path}/config/environment"
  type  = "String"
  tier  = local.ssm_tier
  value = var.environment

  tags = merge(local.common_tags, { Name = "${lower(var.name)}-config-environment" })
}

resource "aws_ssm_parameter" "config_name" {
  name  = "${local.ssm_path}/config/name"
  type  = "String"
  tier  = local.ssm_tier
  value = var.name

  tags = merge(local.common_tags, { Name = "${lower(var.name)}-config-name" })
}

resource "aws_ssm_parameter" "network_cidr" {
  name  = "${local.ssm_path}/network/cidr"
  type  = "String"
  tier  = local.ssm_tier
  value = var.cidr

  tags = merge(local.common_tags, { Name = "${lower(var.name)}-network-cidr" })
}

resource "aws_ssm_parameter" "network_region" {
  name  = "${local.ssm_path}/network/region"
  type  = "String"
  tier  = local.ssm_tier
  value = var.region

  tags = merge(local.common_tags, { Name = "${lower(var.name)}-network-region" })
}

# References the IAM role — depends on aws_iam_role.workload
resource "aws_ssm_parameter" "iam_role_arn" {
  name  = "${local.ssm_path}/iam/role-arn"
  type  = "String"
  tier  = local.ssm_tier
  value = aws_iam_role.workload.arn

  tags = merge(local.common_tags, { Name = "${lower(var.name)}-iam-role-arn" })
}

# References the S3 bucket — depends on aws_s3_bucket.this (conditional)
resource "aws_ssm_parameter" "storage_bucket" {
  count = var.enable_s3 ? 1 : 0
  name  = "${local.ssm_path}/storage/bucket"
  type  = "String"
  tier  = local.ssm_tier
  value = aws_s3_bucket.this[0].id

  tags = merge(local.common_tags, { Name = "${lower(var.name)}-storage-bucket" })
}

# -----------------------------------------------------------------------------
# IAM: Workload Role, Instance Profile, S3 Policy (conditional)
# -----------------------------------------------------------------------------

resource "aws_iam_role" "workload" {
  name = "${lower(var.name)}-role-workload"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(local.common_tags, { Name = "${lower(var.name)}-role-workload" })
}

resource "aws_iam_instance_profile" "workload" {
  name = "${lower(var.name)}-instance-profile"
  role = aws_iam_role.workload.name

  tags = merge(local.common_tags, { Name = "${lower(var.name)}-instance-profile" })
}

resource "aws_iam_policy" "s3_access" {
  count       = var.enable_s3 ? 1 : 0
  name        = "${lower(var.name)}-policy-s3-access"
  description = "Allows workload role to read/write the landing zone S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${lower(var.name)}-*",
          "arn:aws:s3:::${lower(var.name)}-*/*"
        ]
      }
    ]
  })

  tags = merge(local.common_tags, { Name = "${lower(var.name)}-policy-s3-access" })
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  count      = var.enable_s3 ? 1 : 0
  role       = aws_iam_role.workload.name
  policy_arn = aws_iam_policy.s3_access[0].arn
}

# -----------------------------------------------------------------------------
# S3: Workload Storage Bucket (conditional)
# -----------------------------------------------------------------------------

resource "aws_s3_bucket" "this" {
  count         = var.enable_s3 ? 1 : 0
  bucket_prefix = "${lower(var.name)}-storage-"

  tags = merge(local.common_tags, { Name = "${lower(var.name)}-storage" })
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.enable_s3 ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.enable_s3 ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count  = var.enable_s3 ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.enable_s3 ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowWorkloadRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.workload.arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.this[0].arn,
          "${aws_s3_bucket.this[0].arn}/*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.this]
}
