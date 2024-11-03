resource "kubernetes_namespace" "arc_runner" {
  metadata {
    name = local.arc_runner_namespace
  }
}

resource "kubernetes_namespace" "arc_system" {
  metadata {
    name = local.arc_system_namespace
  }
}

resource "helm_release" "arc" {
  name             = "arc"
  namespace        = local.arc_system_namespace
  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart            = "gha-runner-scale-set-controller"
  version          = local.arc_version
  create_namespace = true
}

resource "helm_release" "arc_runner" {
  for_each         = toset(local.github_projects)
  name             = "${split("/", each.value)[1]}-arc"
  repository       = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart            = "gha-runner-scale-set"
  namespace        = local.arc_runner_namespace
  version          = local.arc_version
  create_namespace = true

  set_sensitive {
    name  = "githubConfigSecret.github_token"
    value = var.github_token
  }

  set {
    name  = "githubConfigUrl"
    value = "https://github.com/${each.value}"
  }

  depends_on = [
    helm_release.arc,
    kubernetes_namespace.arc_runner
  ]
}
