# Grafana

Grafana is an open-source analytics and monitoring platform. It allows you to query, visualize, alert on,
and understand your metrics no matter where they are stored.
In this guide, you will learn how to set up Grafana on your Cluster using Helm.

## Installation

Add the Grafana Helm repository:

```bash
helm repo add grafana https://grafana.github.io/helm-charts
```

Install the Grafana Helm chart:

```bash
helm install grafana grafana/grafana --namespace grafana --create-namespace
```

This will install Grafana on your Cluster. Your default username is `admin` and the password is auto-generated.
You can retrieve the password by running:

```bash
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

In order to access Grafana to view your dashboards, you can either port-forward into the service,
use a LoadBalancer or the Cloudflared tunnel to expose the service to the internet.

## Loki

You can use Loki for logging and configure it as a datasource in Grafana.

Use the modern `loki` Helm chart over the outdated `loki-stack` chart:

```bash
helm install loki grafana/loki --values loki.values.yaml
```
