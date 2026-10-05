resource "kubernetes_secret" "mysql" {
  metadata {
    name      = "${var.phpmyadmin.name}-mysql"
    namespace = var.phpmyadmin.namespace
  }

  type = "Opaque"

  data = {
    PMA_HOST     = var.phpmyadmin.mysql.host
    PMA_PORT     = tostring(var.phpmyadmin.mysql.port)
    PMA_USER     = var.phpmyadmin.mysql.user
    PMA_PASSWORD = var.phpmyadmin.mysql.password
  }
}

resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.phpmyadmin.name
    namespace = var.phpmyadmin.namespace

    labels = {
      app = var.phpmyadmin.name
    }
  }

  spec {
    replicas = var.phpmyadmin.replicas

    selector {
      match_labels = {
        app = var.phpmyadmin.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.phpmyadmin.name
        }
      }

      spec {
        container {
          name  = var.phpmyadmin.name
          image = var.phpmyadmin.image

          port {
            container_port = var.phpmyadmin.service.target_port
          }

          env {
            name = "PMA_HOST"

            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql.metadata[0].name
                key  = "PMA_HOST"
              }
            }
          }

          env {
            name = "PMA_PORT"

            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql.metadata[0].name
                key  = "PMA_PORT"
              }
            }
          }

          env {
            name = "PMA_USER"

            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql.metadata[0].name
                key  = "PMA_USER"
              }
            }
          }

          env {
            name = "PMA_PASSWORD"

            value_from {
              secret_key_ref {
                name = kubernetes_secret.mysql.metadata[0].name
                key  = "PMA_PASSWORD"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "this" {
  metadata {
    name      = var.phpmyadmin.name
    namespace = var.phpmyadmin.namespace
  }

  spec {
    type = var.phpmyadmin.service.type

    selector = {
      app = var.phpmyadmin.name
    }

    port {
      port        = var.phpmyadmin.service.port
      target_port = var.phpmyadmin.service.target_port
    }
  }
}