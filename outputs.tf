# NETWORK
output "vpc" {
  description = "VPC module output"
  value       = module.vpc.network
}

output "route_table" {
  description = "Route tables VPC"
  value       = module.vpc.route_table
}

# MYSQL
output "mysql_cluster_id" {
  description = "ID Managed MySQL кластера"
  value       = module.mysql.cluster_id
}

output "mysql_cluster_name" {
  description = "Имя Managed MySQL кластера"
  value       = module.mysql.cluster_name
}

output "mysql_fqdn" {
  description = "FQDN хостов Managed MySQL"
  value       = module.mysql.fqdn
}

output "mysql_database" {
  description = "Имя базы данных"
  value       = module.mysql.database_name
}

output "mysql_user" {
  description = "Пользователь MySQL"
  value       = module.mysql.user_name
}