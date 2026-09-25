# DBG Demo 3: Terraform Stacks

Terraform Stacks demonstration modeling 20 Landing Zones as deployments within a single Stack in HCP Terraform.

## Overview

This repository demonstrates **Terraform Stacks** (GA syntax: `.tfcomponent.hcl` and `.tfdeploy.hcl`) to manage 20 landing zones as separate deployments orchestrated from a single configuration layer.

### Architecture

- **Stack Component (`.tfcomponent.hcl`)**: Defines the infrastructure abstraction by referencing the local `modules/landing-zone` module, configuring required AWS providers, inputs, and outputs.
- **Deployments (`.tfdeploy.hcl`)**: Declares 20 distinct deployment instances:
  - 10 in `dev` (`lz_01_dev` through `lz_10_dev`)
  - 10 in `prod` (`lz_11_prod` through `lz_20_prod`)
- **Deployment Groups & Auto-Approval**:
  - `dev`: Auto-approves safe non-destructive changes.
  - `prod`: Requires manual plan review and approval before apply.

## Repository Structure

```
dbg-demo-stacks/
├── .terraform-version          # Pinned Terraform version (1.14.5)
├── variables.tfcomponent.hcl   # Component variable declarations
├── providers.tfcomponent.hcl   # Provider configurations
├── components.tfcomponent.hcl  # Component definition (source: ./modules/landing-zone)
├── outputs.tfcomponent.hcl     # Stack outputs
├── lz-01.tfdeploy.hcl          # Deployment block for lz-01
├── lz-02.tfdeploy.hcl          # Deployment block for lz-02
├── ...                         # Individual .tfdeploy.hcl files (lz-01 to lz-20)
├── lz-20.tfdeploy.hcl          # Deployment block for lz-20
├── deployments.tfdeploy.hcl    # Deployment configurations
├── modules/
│   └── landing-zone/           # Local landing-zone module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── DEMO.md                     # Live demo script & comparison guide
└── README.md                   # This file
```

## CLI Usage

```bash
# Initialize and validate stack configuration
terraform stacks init
terraform stacks validate

# Upload stack configuration (triggers deployment runs in HCP Terraform)
terraform stacks configuration upload

# List and monitor deployment runs
terraform stacks deployment-run list
terraform stacks deployment-group watch -deployment-group=dev
```
