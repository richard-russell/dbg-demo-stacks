deployment "lz_15" {
  inputs = {
    name                = "stack-lz-15"
    cidr                = "10.15.0.0/16"
    environment         = "dev"
    region              = "eu-west-1"
    enable_s3           = true
    enable_ssm_advanced = true
    extra_tags          = { Demo = "demo-3-stacks", Deployment = "lz-15" }
  }

  deployment_group = deployment_group.dev
}
