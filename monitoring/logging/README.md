# logging

This doc gets you a quick-start on logging, integrating with an existing Grafana instance.
It will create a minimal instance of Loki, as well as a fluentd Daemonset that will transform
and push your logs to Loki.

## Installation

Add the Grafana Helm repo:

```
helm repo add grafana https://grafana.github.io/helm-charts
```

Add the fluent Helm Repo:

```
helm repo add fluent https://fluent.github.io/helm-charts
```

Install the charts:

```
helm install fluent-bit fluent/fluent-bit --values fluent.values.yaml
helm install loki grafana/loki --values loki.values.yaml
```

You should see fluent-bit pushing logs to Loki now!
