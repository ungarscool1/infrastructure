# infrastructure
GitOps infrastructure repository for my homelab.

## Components

- Kubernetes (soon™️)
  - Applications (managed by ArgoCD)
  - Infrastructure (managed by Terraform)

## Upgrade K3s

> [!WARNING]
> You must use ubuntu as user to run this script.

Run this on a bootstrap/your own machine:

```bash
wget https://raw.githubusercontent.com/ungarscool1/infrastructure/main/scripts/upgrade_k3s.sh
chmod +x upgrade_k3s.sh
./upgrade_k3s.sh
```
