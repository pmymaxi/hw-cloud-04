output "cluster_id" {
  description = "ID Managed Kubernetes кластера"
  value       = yandex_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "Имя Managed Kubernetes кластера"
  value       = yandex_kubernetes_cluster.this.name
}

output "cluster_endpoint" {
  description = "Внешний endpoint Kubernetes API"
  value       = yandex_kubernetes_cluster.this.master[0].external_v4_endpoint
}

output "cluster_ca_certificate" {
  description = "CA certificate Kubernetes API"
  value       = yandex_kubernetes_cluster.this.master[0].cluster_ca_certificate
  sensitive   = true
}

output "node_group_id" {
  description = "ID группы узлов"
  value       = yandex_kubernetes_node_group.this.id
}

output "node_group_name" {
  description = "Имя группы узлов"
  value       = yandex_kubernetes_node_group.this.name
}