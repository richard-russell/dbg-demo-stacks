deployment "lz_10" {
  inputs = {
    name                = "stack-lz-10"
    cidr                = "10.10.0.0/16"
    environment         = "dev"
    region              = "eu-west-1"
    enable_s3           = true
    enable_ssm_advanced = true
    extra_tags          = { Demo = "demo-3-stacks", Deployment = "lz-10" }
  }
}
