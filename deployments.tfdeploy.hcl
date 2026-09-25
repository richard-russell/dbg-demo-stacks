# -----------------------------------------------------------------------------
# Deployment Group & Auto-Approve Rules
# Groups all 20 landing zone deployments into the dev deployment group
# -----------------------------------------------------------------------------

deployment_group "dev" {
  deployments = [
    deployment.lz_01,
    deployment.lz_02,
    deployment.lz_03,
    deployment.lz_04,
    deployment.lz_05,
    deployment.lz_06,
    deployment.lz_07,
    deployment.lz_08,
    deployment.lz_09,
    deployment.lz_10,
    deployment.lz_11,
    deployment.lz_12,
    deployment.lz_13,
    deployment.lz_14,
    deployment.lz_15,
    deployment.lz_16,
    deployment.lz_17,
    deployment.lz_18,
    deployment.lz_19,
    deployment.lz_20
  ]
}

deployment_auto_approve "safe_changes" {
  deployment_group = deployment_group.dev

  check {
    condition = context.plan.applyable
    reason    = "Plan must be applyable without errors"
  }

  check {
    condition = context.plan.changes.remove == 0
    reason    = "Plans with resource deletions require manual approval"
  }
}
