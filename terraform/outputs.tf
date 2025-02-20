output "external_ip" {
  value = kubernetes_service.hello_service.status.0.load_balancer.0.ingress.0.ip
}