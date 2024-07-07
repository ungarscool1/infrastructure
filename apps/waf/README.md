# Custom made WAF for Traefik

## Description

I'm using the crowdsec WAF for Traefik and adding custom rules (ip whitelist, HTTPS redirect). The WAF need the execution of the [`cert-manager`](https://github.com/ungarscool1/infrastructure/tree/main/stack/cert-manager) stack to have the default certificate for the domain.

## Usage

```bash
cd stack/cert-manager
terraform init
terraform apply
cd ../../apps/waf
helm install waf . -n waf
```

## Configuration

You need to customize the `values.yaml` file to your needs. There are some variables that you need to change:
- `crowdsec.agent.env.TZ`: Timezone
- `crowdsec.lapi.env.TZ`: Timezone
- `crowdsec.lapi.env.ENROLL_KEY`: Enrollment key (here we use a secret from vault)