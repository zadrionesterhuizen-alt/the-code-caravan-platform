# Operations Guide

## Daily Checks

```bash
kubectl get pods -A
kubectl get applications -n argocd
kubectl get gateways -A
kubectl get httproutes -A
```

## Argo CD Access

Port-forward:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open:

```text
https://localhost:8080
```

## Get Initial Argo CD Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

## Platform Upgrade Strategy

All changes should be made through pull requests.

Flow:

```text
Change repo
  ↓
Pull request
  ↓
Terraform plan / validation
  ↓
Merge
  ↓
Run apply/bootstrap workflow
```

## No Direct Production Changes

Avoid:

```bash
kubectl apply -f production-file.yaml
```

Prefer:

```text
Git commit → GitHub Actions → Argo CD
```
