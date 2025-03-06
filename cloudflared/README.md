# cloudflared

Explanation ...

## Installation

Set up Helm:

```bash
helm repo add strrl.dev https://helm.strrl.dev
helm repo update
```

Install:

```bash
helm upgrade --install --wait \
  -n cloudflare-tunnel-ingress-controller --create-namespace \
  cloudflare-tunnel-ingress-controller \
  strrl.dev/cloudflare-tunnel-ingress-controller \
  --values values.yaml 
```