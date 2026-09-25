deployment "lz_17" {
  inputs = {
    name                = "stack-lz-17"
    cidr                = "10.17.0.0/16"
    environment         = "dev"
    region              = "eu-west-1"
    enable_s3           = true
    enable_ssm_advanced = true
    extra_tags          = { Demo = "demo-3-stacks", Deployment = "lz-17" }
  }

  deployment_group = deployment_group.dev
}
