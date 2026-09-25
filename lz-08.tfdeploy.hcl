deployment "lz_08" {
  inputs = {
    name                = "stack-lz-08"
    cidr                = "10.8.0.0/16"
    environment         = "dev"
    region              = "eu-west-1"
    enable_s3           = true
    enable_ssm_advanced = true
    extra_tags          = { Demo = "demo-3-stacks", Deployment = "lz-08" }
  }

  deployment_group = deployment_group.dev
}
