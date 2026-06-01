# The Code Caravan Platform Bootstrap

This repository is designed to bootstrap the empty platform for The Code Caravan.

It creates and manages:

- GCP base services
- GKE Autopilot cluster
- Artifact Registry
- Platform namespaces
- Argo CD
- Istio
- Kubernetes Gateway API
- cert-manager
- External Secrets Operator
- Observability stack
- Base platform Gateway
- GitHub Actions automation

No client applications are deployed by default.

The goal is simple:

```text
Clone repo
  ↓
Configure GitHub secrets / variables
  ↓
Run GitHub Actions
  ↓
Empty platform is ready
  ↓
Add clients later through GitOps
```

## Repository Structure

```text
.
├── .github/workflows/
├── docs/
├── terraform/
├── platform/
├── argocd/
├── scripts/
└── clients/
```

## Main Workflows

### 1. Terraform Plan

Runs on pull request.

```text
.github/workflows/terraform-plan.yml
```

### 2. Terraform Apply

Manually triggered from GitHub Actions.

```text
.github/workflows/terraform-apply.yml
```

### 3. Bootstrap Platform

Installs Kubernetes platform services after the cluster exists.

```text
.github/workflows/bootstrap-platform.yml
```

### 4. Add Client

Generates starter files for a new client.

```text
.github/workflows/add-client.yml
```

## Setup Summary

1. Create a GCP project.
2. Create GitHub OIDC Workload Identity Federation.
3. Add GitHub repository variables.
4. Run `Terraform Apply`.
5. Run `Bootstrap Platform`.
6. Add clients later using the `Add Client` workflow.

See:

```text
docs/SETUP.md
docs/ADD_CLIENT.md
```
