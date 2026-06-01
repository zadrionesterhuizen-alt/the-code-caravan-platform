#!/usr/bin/env bash
set -euo pipefail

echo "Applying platform namespaces..."
kubectl apply -f platform/namespaces/platform-namespaces.yaml

echo "Installing Argo CD..."
kubectl apply --server-side --force-conflicts -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Installing Gateway API CRDs..."
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/latest/download/standard-install.yaml

echo "Installing Istio..."
curl -L https://istio.io/downloadIstio | sh -
ISTIO_DIR=$(find . -maxdepth 1 -type d -name 'istio-*' | head -n 1)
export PATH="$PWD/$ISTIO_DIR/bin:$PATH"
istioctl install --set profile=default -y

echo "Installing cert-manager..."
helm repo add jetstack https://charts.jetstack.io || true
helm repo update
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set crds.enabled=true

echo "Installing External Secrets Operator..."
helm repo add external-secrets https://charts.external-secrets.io || true
helm repo update
helm upgrade --install external-secrets external-secrets/external-secrets \
  --namespace external-secrets \
  --create-namespace

echo "Installing observability stack..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
helm repo add grafana https://grafana.github.io/helm-charts || true
helm repo update

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace observability \
  --create-namespace

helm upgrade --install loki grafana/loki \
  --namespace observability

helm upgrade --install tempo grafana/tempo \
  --namespace observability

echo "Applying base platform Gateway..."
kubectl apply -f platform/gateway/platform-gateway.yaml

echo "Bootstrap complete."
kubectl get pods -A
