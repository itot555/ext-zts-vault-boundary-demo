locals {
  service_account_name = "vault"
}

resource "kubernetes_namespace" "vault" {
  metadata {
    annotations = {
      name = "vault"
    }

    labels = {
      env = "eks"
    }

    name = "vault"
  }
  depends_on = [
    module.eks
  ]
}

resource "kubernetes_service_account_v1" "vault" {
  metadata {
    name      = local.service_account_name
    namespace = kubernetes_namespace.vault.metadata.0.name
  }
}

resource "kubernetes_cluster_role_v1" "vault" {
  metadata {
    name = "k8s-full-secrets-abilities-with-labels"
  }

  rule {
    api_groups = [""]
    resources  = ["namespaces"]
    verbs      = ["get"]
  }

  rule {
    api_groups = [""]
    resources  = ["serviceaccounts", "serviceaccounts/token"]
    verbs      = ["create", "update", "delete"]
  }

  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["rolebindings", "clusterrolebindings"]
    verbs      = ["create", "update", "delete"]
  }

  rule {
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["roles", "clusterroles"]
    verbs      = ["bind", "escalate", "create", "update", "delete"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "vault" {
  metadata {
    name = "vault-token-creator-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "k8s-full-secrets-abilities-with-labels"
  }
  subject {
    kind      = "ServiceAccount"
    name      = local.service_account_name
    namespace = kubernetes_namespace.vault.metadata.0.name
  }
}

resource "kubernetes_secret_v1" "vault" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = "${local.service_account_name}"
    }

    namespace = kubernetes_namespace.vault.metadata.0.name
    name      = "vault"
  }

  type = "kubernetes.io/service-account-token"

  depends_on = [
    kubernetes_service_account_v1.vault
  ]
}

data "kubernetes_secret_v1" "vault" {
  metadata {
    name = kubernetes_secret_v1.vault.metadata.0.name
  }
  depends_on = [
    kubernetes_secret_v1.vault
  ]
}

# Sample app
resource "kubernetes_deployment_v1" "sample" {
  metadata {
    name = "vault-k8s-secrets-engine-test"
    labels = {
      test = "boundary-and-vault"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "boundary-and-vault"
      }
    }

    template {
      metadata {
        labels = {
          test = "boundary-and-vault"
        }
      }

      spec {
        container {
          image = "nginx:1.21.6"
          name  = "boundary-and-vault"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}