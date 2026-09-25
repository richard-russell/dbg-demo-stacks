component "landing_zone" {
  source = "./modules/landing-zone"

  inputs = {
    name                = var.name
    environment         = var.environment
    cidr                = var.cidr
    region              = var.region
    enable_s3           = var.enable_s3
    enable_ssm_advanced = var.enable_ssm_advanced
    extra_tags          = var.extra_tags
  }

  providers = {
    aws = provider.aws.this
  }
}
