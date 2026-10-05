output "cluster_id" {
  description = "ID Managed MySQL кластера"
  value       = yandex_mdb_mysql_cluster.this.id
}

output "cluster_name" {
  description = "Имя Managed MySQL кластера"
  value       = nonsensitive(yandex_mdb_mysql_cluster.this.name)
}

output "fqdn" {
  description = "FQDN хостов Managed MySQL"
  value       = yandex_mdb_mysql_cluster.this.host[*].fqdn
}

output "database_name" {
  description = "Имя базы данных"
  value       = nonsensitive(yandex_mdb_mysql_database.this.name)
}

output "user_name" {
  description = "Имя пользователя MySQL"
  value       = nonsensitive(yandex_mdb_mysql_user.this.name)
}