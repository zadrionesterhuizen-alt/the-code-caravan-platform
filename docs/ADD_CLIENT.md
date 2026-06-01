# Add a New Client

The platform starts empty. Clients are added through GitOps.

## Client Inputs

When adding a client, decide:

```text
CLIENT_SLUG=client-a
ENVIRONMENTS=staging,prod
DOMAIN=client-a.com
```

## What Gets Created

For each client:

```text
clients/client-a/
├── namespaces/
├── gateway/
├── external-secrets/
├── argocd/
└── values/
```

The workflow can create:

- `client-a-staging` namespace
- `client-a-prod` namespace
- HTTPRoute placeholders
- ExternalSecret placeholders
- Argo CD Application placeholders
- Helm values placeholders

## Client Architecture

```text
client-a-prod
├── frontend
├── api
├── worker
├── service
├── httproute
└── externalsecret
```

## Database Rule

Start with one shared Cloud SQL instance, but use:

- one database per client
- one database user per client

Do not put all client data into one database using only `tenant_id`.
