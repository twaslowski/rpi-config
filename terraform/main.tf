terraform {
  backend "kubernetes" {
    secret_suffix     = "state"
    in_cluster_config = false
    config_path       = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
