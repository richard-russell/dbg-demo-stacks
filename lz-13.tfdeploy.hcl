deployment "lz_13" {
  inputs = {
    name                = "stack-lz-13"
    cidr                = "10.13.0.0/16"
    environment         = "dev"
    region              = "eu-west-1"
    enable_s3           = true
    enable_ssm_advanced = true
    extra_tags          = { Demo = "demo-3-stacks", Deployment = "lz-13" }
  }

  deployment_group = deployment_group.dev
}
