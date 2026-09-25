# -----------------------------------------------------------------------------
# Deployment Configuration & Workload Identity
# -----------------------------------------------------------------------------

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

locals {
  role_arn = "arn:aws:iam::363715248670:role/tfc-workload-identity-richard-russell-org"
}
