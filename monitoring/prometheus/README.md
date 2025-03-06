# Prometheus

Prometheus is a monitoring and alerting toolkit. It collects metrics from configured targets at given intervals, 
evaluates rule expressions, displays the results, and can trigger alerts if some condition is observed to be true.

This guide helps you set up a Prometheus instance on your Cluster using Helm.

## Installation

Add the Prometheus Helm repository:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

Install the main prometheus-server Helm chart:

```bash
helm install prometheus prometheus-community/prometheus
```

This will install the Prometheus server as well as:

- alertmanager
- kube-state-metrics
- prometheus-node-exporter
- prometheus-pushgateway

For more info, [see here](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus#install-chart).

## Scraping Services

To scrape services, you need to add annotations to your Kubernetes resources. For example, to scrape a service, add the following annotations:

```yaml
metadata:
  annotations:
    annotations:
    prometheus.io/path: /actuator/prometheus
    prometheus.io/port: "8080"
    prometheus.io/scrape: "true"
```

This will scrape the service at the `/actuator/prometheus` path on port `8080`.

Check out the guide on [Grafana](#../grafana/README.md) to learn how to visualize the metrics collected by Prometheus.