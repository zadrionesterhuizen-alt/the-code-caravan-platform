# GitHub OIDC Setup for GCP

This platform should use GitHub Actions with Workload Identity Federation.

This avoids storing long-lived GCP service account keys in GitHub.

## High-Level Flow

```text
GitHub Actions
  ↓
OIDC Token
  ↓
GCP Workload Identity Provider
  ↓
GCP Service Account
  ↓
Terraform / gcloud / kubectl
```

## Required GitHub Variables

```text
GCP_WORKLOAD_IDENTITY_PROVIDER
GCP_SERVICE_ACCOUNT
```

## Recommended Service Account

```text
github-platform-deployer@PROJECT_ID.iam.gserviceaccount.com
```

## Minimum Permissions During Bootstrap

For the first bootstrap, the service account needs broad permissions.

After the platform is stable, reduce permissions.

Initial roles may include:

```text
roles/container.admin
roles/artifactregistry.admin
roles/iam.serviceAccountAdmin
roles/serviceusage.serviceUsageAdmin
roles/secretmanager.admin
roles/compute.admin
roles/storage.admin
```

For production, split this into separate service accounts:

- terraform-deployer
- platform-bootstrapper
- app-deployer
