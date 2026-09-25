deployment "lz_16_dev" {
  inputs = {
    name                = "stack-lz-16-dev"
    cidr                = "10.16.0.0/16"
    environment         = "dev"
    region              = "eu-west-1"
    enable_s3           = true
    enable_ssm_advanced = true
    extra_tags          = { Demo = "demo-3-stacks", Deployment = "lz-16-dev", Environment = "dev" }
    role_arn            = local.role_arn
    identity_token      = identity_token.aws.jwt
  }

  deployment_group = deployment_group.dev
 }

deployment "lz_16_test" {
  inputs = {
    name                = "stack-lz-16-test"
    cidr                = "10.16.0.0/16"
    environment         = "test"
    region              = "eu-west-1"
    enable_s3           = true
    enable_ssm_advanced = true
    extra_tags          = { Demo = "demo-3-stacks", Deployment = "lz-16-test", Environment = "test" }
    role_arn            = local.role_arn
    identity_token      = identity_token.aws.jwt
  }

  deployment_group = deployment_group.test
}

deployment "lz_16_prod" {
  inputs = {
    name                = "stack-lz-16-prod"
    cidr                = "10.16.0.0/16"
    environment         = "prod"
    region              = "eu-west-1"
    enable_s3           = true
    enable_ssm_advanced = true
    extra_tags          = { Demo = "demo-3-stacks", Deployment = "lz-16-prod", Environment = "prod" }
    role_arn            = local.role_arn
    identity_token      = identity_token.aws.jwt
  }

  deployment_group = deployment_group.prod
}
