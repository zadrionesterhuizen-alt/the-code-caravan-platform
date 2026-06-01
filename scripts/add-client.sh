#!/usr/bin/env bash
set -euo pipefail

CLIENT_SLUG="${1:?Usage: ./scripts/add-client.sh client-slug domain.com}"
DOMAIN="${2:?Usage: ./scripts/add-client.sh client-slug domain.com}"

CLIENT_DIR="clients/${CLIENT_SLUG}"
mkdir -p "${CLIENT_DIR}/namespaces" "${CLIENT_DIR}/gateway" "${CLIENT_DIR}/argocd" "${CLIENT_DIR}/external-secrets"

cat > "${CLIENT_DIR}/namespaces/namespaces.yaml" <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: ${CLIENT_SLUG}-staging
  labels:
    client: ${CLIENT_SLUG}
    environment: staging
---
apiVersion: v1
kind: Namespace
metadata:
  name: ${CLIENT_SLUG}-prod
  labels:
    client: ${CLIENT_SLUG}
    environment: production
EOF

cat > "${CLIENT_DIR}/gateway/httproute-prod.yaml" <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: ${CLIENT_SLUG}-prod
  namespace: ${CLIENT_SLUG}-prod
spec:
  parentRefs:
    - name: platform-gateway
      namespace: platform-gateway
  hostnames:
    - "${DOMAIN}"
  rules:
    - backendRefs:
        - name: ${CLIENT_SLUG}-app
          port: 80
EOF

cat > "${CLIENT_DIR}/external-secrets/db-secret-prod.yaml" <<EOF
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  name: ${CLIENT_SLUG}-db
  namespace: ${CLIENT_SLUG}-prod
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: gcp-secret-store
    kind: ClusterSecretStore
  target:
    name: ${CLIENT_SLUG}-db
    creationPolicy: Owner
  data:
    - secretKey: DATABASE_URL
      remoteRef:
        key: ${CLIENT_SLUG}-prod-db-url
EOF

cat > "${CLIENT_DIR}/README.md" <<EOF
# ${CLIENT_SLUG}

Domain:

\`\`\`text
${DOMAIN}
\`\`\`

Namespaces:

\`\`\`text
${CLIENT_SLUG}-staging
${CLIENT_SLUG}-prod
\`\`\`

This folder contains the GitOps placeholders for the client.
EOF

echo "Created client scaffold at ${CLIENT_DIR}"
