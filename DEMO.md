# Demo 3 Walkthrough & Comparison: Terraform Stacks

This guide demonstrates how **Terraform Stacks** models 20 landing zones and directly compares the operational characteristics against **Demo 1 (Monoworkspace)** and **Demo 2 (Multiworkspace)**.

---

## Key Concepts Demonstrated

1. **Declarative Multi-Deployment Orchestration**:
   Instead of writing 20 separate workspace boilerplate configurations or 20 distinct module calls in a single monolithic state, Stacks separates the **Component definition** (`.tfcomponent.hcl`) from the **Deployment definitions** (`.tfdeploy.hcl`).

2. **Per-Deployment State Isolation**:
   Every deployment (`lz_01` ... `lz_20`) maintains its own independent state file within HCP Terraform. A failure or state lock in `lz_05` has zero impact on `lz_01` or `lz_20`.

3. **Component Change Fan-Out**:
   Updating a shared component automatically creates coordinated deployment runs across all 20 deployments simultaneously.

4. **Deployment-Specific Modifications**:
   Modifying variable inputs for a single deployment in `deployments.tfdeploy.hcl` targets that deployment while preserving the rest.

---

## Live Demo Walkthrough

### Scenario A: Deployment-Level Change (Targeted Blast Radius)

**Action**: Modify an input for a single landing zone (e.g., update `extra_tags` in [`lz-11.tfdeploy.hcl`](dbg-demo-stacks/lz-11.tfdeploy.hcl:1)).

```hcl
deployment "lz_11_dev" {
  inputs = {
    name                = "stack-lz-11-dev"
    cidr                = "10.11.0.0/16"
    environment         = "dev"
    region              = "eu-west-1"
    enable_s3           = true
    enable_ssm_advanced = true
    extra_tags          = { Demo = "demo-3-stacks", Deployment = "lz-11-dev", Environment = "dev", Updated = "true" }
    role_arn            = local.role_arn
    identity_token      = identity_token.aws.jwt
  }

  deployment_group = deployment_group.dev
}
```

**Observation**:
- HCP Terraform evaluates the stack plan.
- Only deployment `lz_11` produces resource changes.
- Other deployments evaluate with zero changes or are skipped.

---

### Scenario B: Component-Level Change (Coordinated Rollout)

**Action**: Add an SSM parameter or tag in `modules/landing-zone/main.tf`.

**Observation**:
- A single configuration upload or VCS push triggers runs across all 20 deployments.
- Demonstrates Stacks' strength: **Zero manual scripting required to coordinate a fleet-wide update**.
- Deployment plans run across all 60 deployments (dev, test, prod).
- Deployments in `dev` and `test` groups automatically approve if non-destructive changes are detected.
- Deployments in `prod` pause at the plan stage, requiring explicit manual review and approval before apply.

---

## Architecture Comparison Matrix

| Dimension | Demo 1: Monoworkspace | Demo 2: Multiworkspace | Demo 3: Stacks |
|---|---|---|---|
| **State Boundaries** | 1 monolithic state (~400 resources) | 20 isolated workspace states | 20 isolated deployment states |
| **VCS Triggering** | Entire repo triggers single plan | Path-filtered per LZ directory | Stack-level trigger with fan-out |
| **Plan & Apply Time** | Slowest (full estate refresh unless minimal refresh used) | Fast (parallel per-workspace runs) | Fast (isolated per-deployment runs) |
| **Fleet-wide Rollout** | 1 run applies everything (high blast radius) | Requires multi-workspace trigger (API / UI) | Native coordinated fan-out across deployments |
| **Configuration Overhead** | Low (single directory) | Moderate (20 workspace configs + bootstrap) | Lowest boilerplate (1 component + deployment blocks) |
| **Governance & Approvals** | All-or-nothing run approval | Per-workspace approval / Run Tasks | `deployment_group` & `deployment_auto_approve` policies |

---

## Addressing Deutsche Börse Objections

### 1. "How do we review plans across 20–40 Landing Zones?"
- In Stacks, HCP Terraform provides a unified Stack overview displaying the plan status across all 20 deployments in one pane, while keeping execution isolated.

### 2. "How do we apply fleet-wide changes at once without manual toil?"
- Stacks natively orchestrates deployment runs across all deployments when component definitions change. Combined with `deployment_auto_approve`, non-breaking changes roll out seamlessly.

### 3. "When should we choose Multiworkspace vs. Stacks?"
- **Multiworkspace**: Ideal when landing zones are owned by disparate teams requiring separate VCS repositories, different release cadences, or custom RBAC per workspace.
- **Stacks**: Ideal when a central platform team manages many instances of standard infrastructure (landing zones, clusters, regional replicas) that share a lifecycle.
