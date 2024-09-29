# ArgoCD stack

> [!WARNING]
> This stack has multiple dependencies, please make sure to have them installed before deploying this stack.

## Workspaces

- `default`: Is production environment.
- `staging`: Is everything else.

## Prerequisites

- Kubernetes 1.30+
- Have installed the `cert-manager` and `vault` stack.

## Deploy

Extract the SOPS GPG key IN the same folder as this tf stack:
```bash
gpg --armor --export-secret-keys <key-id> > sops.key
```

```bash
tfi
tfa -auto-approve
```
