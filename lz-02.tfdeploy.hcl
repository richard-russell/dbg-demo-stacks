deployment "lz_02" {
  inputs = {
    name                = "stack-lz-02"
    cidr                = "10.2.0.0/16"
    environment         = "dev"
    region              = "eu-west-1"
    enable_s3           = true
    enable_ssm_advanced = true
    extra_tags          = { Demo = "demo-3-stacks", Deployment = "lz-02" }
    role_arn            = local.role_arn
    identity_token      = identity_token.aws.jwt
  }
}
