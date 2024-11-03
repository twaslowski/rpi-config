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
    resources  = ["*"]
    verbs      = ["list", "create", "get", "delete", "patch", "update"]
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