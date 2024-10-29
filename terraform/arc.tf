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
  for_each = toset(local.github_projects)
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

  set {
    name  = "template.spec.serviceAccountName"
    value = kubernetes_service_account.runner_service_account.metadata[0].name
  }

  depends_on = [
    helm_release.arc,
    kubernetes_namespace.arc_runner
  ]
}

resource "kubernetes_service_account" "runner_service_account" {
  metadata {
    name      = "arc-runner-sa"
    namespace = local.arc_runner_namespace
  }

  depends_on = [kubernetes_namespace.arc_runner]
}

resource "kubernetes_cluster_role" "runner_role" {
  metadata {
    name = "runner-role"
  }

  rule {
    api_groups = ["*"]
    resources = ["*"]
    verbs = ["get", "list", "watch", "create", "update", "patch", "delete"]
  }
}

resource "kubernetes_cluster_role_binding" "runner_role_binding" {
  metadata {
    name = "runner-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.runner_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.runner_service_account.metadata[0].name
    namespace = kubernetes_service_account.runner_service_account.metadata[0].namespace
  }
}