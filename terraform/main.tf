# main.tf

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host  = "https://${google_container_cluster.hello_cluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.hello_cluster.master_auth[0].cluster_ca_certificate,
  )
}

data "google_client_config" "default" {}

resource "google_container_cluster" "hello_cluster" {
  name               = "hello-cluster"
  location           = var.zone
  initial_node_count = 1

  node_config {
    machine_type = "e2-small"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "kubernetes_deployment" "hello_server" {
  metadata {
    name = "hello-server"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "hello-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "hello-server"
        }
      }

      spec {
        container {
          image = "image = "vitalikmal/golangt:${var.app_version}""
          name  = "hello-app"
          env {
            name  = "APP_VERSION"
            value = var.app_version
  }
          port {
            container_port = 8080
          }
        }
      }
    }
  }

  depends_on = [google_container_cluster.hello_cluster]
}

resource "kubernetes_service" "hello_service" {
  metadata {
    name = "hello-server"
  }

  spec {
    selector = {
      app = kubernetes_deployment.hello_server.spec.0.template.0.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

output "external_ip" {
  value = kubernetes_service.hello_service.status.0.load_balancer.0.ingress.0.ip
}