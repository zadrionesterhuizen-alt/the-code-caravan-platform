# Platform Setup Guide

This guide explains how to set up The Code Caravan platform using GitHub Actions.

The platform starts empty. No client applications are deployed by default.

## Required GitHub Repository Variables

Add these under:

```text
GitHub Repository → Settings → Secrets and variables → Actions → Variables
```

Required variables:

```text
GCP_PROJECT_ID
GCP_REGION
GKE_CLUSTER_NAME
ARTIFACT_REGISTRY_NAME
GAR_LOCATION
GCP_WORKLOAD_IDENTITY_PROVIDER
GCP_SERVICE_ACCOUNT
```

Recommended values:

```text
GCP_REGION=europe-west1
GKE_CLUSTER_NAME=code-caravan-platform
ARTIFACT_REGISTRY_NAME=code-caravan-images
GAR_LOCATION=europe-west1
```

## Required GitHub Secrets

Ideally, use GitHub OIDC instead of service account keys.

Only add secrets if absolutely required.

## Step 1: Run Terraform Apply

Go to:

```text
Actions → Terraform Apply → Run workflow
```

This creates:

- GKE Autopilot cluster
- Artifact Registry
- Base IAM bindings
- Required APIs

## Step 2: Run Bootstrap Platform

Go to:

```text
Actions → Bootstrap Platform → Run workflow
```

This installs:

- Argo CD
- Istio
- Gateway API CRDs
- cert-manager
- External Secrets Operator
- kube-prometheus-stack
- Loki
- Tempo
- Platform namespaces
- Platform Gateway placeholder

## Step 3: Verify Cluster

From your local machine:

```bash
gcloud container clusters get-credentials code-caravan-platform \
  --region europe-west1 \
  --project YOUR_PROJECT_ID

kubectl get ns
kubectl get pods -A
```

## Step 4: Platform Is Ready

At this point, the platform has no clients.

To add a client later, use:

```text
Actions → Add Client → Run workflow
```
