# -----------------------------------------------------------------------------
# Deployment Configuration & Workload Identity
# -----------------------------------------------------------------------------

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

locals {
  role_arn = "arn:aws:iam::363715248670:role/tfc-workload-identity-richard-russell-org"
}

# -----------------------------------------------------------------------------
# Deployment Group & Auto-Approval
# -----------------------------------------------------------------------------

deployment_auto_approve "safe_changes" {
  check {
    condition = context.plan.applyable
    reason    = "Plan must be applyable without errors"
  }

  check {
    condition = context.plan.changes.remove == 0
    reason    = "Plans with resource deletions require manual approval"
  }
}

deployment_group "dev" {
  auto_approve_checks = [deployment_auto_approve.safe_changes]
}
