provider "google" {
  
  project = var.project_id
  region  = var.region
}
resource "google_storage_bucket" "logs_bucket" {
  name          = "hello-app-logs-${var.project_id}"  
  location      = var.region
  force_destroy = true  
  lifecycle_rule {
    condition {
      age = 30  
    }
    action {
      type = "Delete"
    }
  }
}

data "google_client_config" "default" {}

data "google_container_cluster" "hello_cluster" {
  name     = google_container_cluster.hello_cluster.name
  location = var.zone
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.hello_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.hello_cluster.master_auth[0].cluster_ca_certificate)
}

resource "google_container_cluster" "hello_cluster" {
  name               = "hello-cluster"
  location           = var.zone
  initial_node_count = 1
  deletion_protection = false
  logging_service    = "logging.googleapis.com/kubernetes"  #  Cloud Logging
  monitoring_service = "monitoring.googleapis.com/kubernetes"  #   Cloud Monitoring
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
    labels = {
      app = "hello-server"
    }
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
          image = "vitalikmal/hello-app:${var.app_version}" 
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
      app = "hello-server" 
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
resource "google_logging_project_sink" "logs_sink" {
  name        = "hello-app-logs-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.logs_bucket.name}"
  filter      = "resource.type=\"k8s_container\" resource.labels.cluster_name=\"${google_container_cluster.hello_cluster.name}\""
}
resource "google_project_iam_binding" "logs_sink_iam" {
  project = var.project_id
  role    = "roles/storage.objectCreator"

  members = [
    google_logging_project_sink.logs_sink.writer_identity,
  ]
}

output "external_ip" {
  value = kubernetes_service.hello_service.status.0.load_balancer.0.ingress.0.ip
}
