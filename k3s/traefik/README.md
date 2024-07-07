# Traefik WAF ??

Is it a WAF to only allow traffic from local IPs? Or is it a firewall?

## Setup

To set the LB service to see your IP:
```bash
  kubectl apply -f service.yaml
```

## IP Whitelist

Here is for my local network:

```bash
  kubectl apply -f ipwhitelist.yaml -n default
```

## HTTP -> HTTPS

```bash
  kubectl apply -f http2https.yaml -n default
```