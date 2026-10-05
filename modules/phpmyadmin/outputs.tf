output "deployment_name" {
  description = "Имя Deployment phpMyAdmin"
  value       = kubernetes_deployment.this.metadata[0].name
}

output "service_name" {
  description = "Имя Service phpMyAdmin"
  value       = kubernetes_service.this.metadata[0].name
}

output "service_type" {
  description = "Тип Service phpMyAdmin"
  value       = kubernetes_service.this.spec[0].type
}

output "service_port" {
  description = "Порт Service phpMyAdmin"
  value       = kubernetes_service.this.spec[0].port[0].port
}