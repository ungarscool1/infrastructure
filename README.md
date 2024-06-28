# infrastructure
GitOps infrastructure repository for my homelab.

## Components

- Kubernetes (soon™️)
  - Applications (managed by ArgoCD)
  - Infrastructure (managed by Terraform)

## Upgrade K3s

Run this on each k3s node:

```bash
wget https://raw.githubusercontent.com/ungarscool1/infrastructure/main/scripts/upgrade_k3s.sh
chmod +x upgrade_k3s.sh
sudo ./upgrade_k3s.sh # sudo to be sure it has the right permissions
```

After the first upgrade, it will be possible to just run:

```bash
ssh <user>@<node> 'sudo ./upgrade_k3s.sh'
```
