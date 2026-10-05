output "id" {
  description = "ID DNS зоны"
  value       = yandex_dns_zone.this.id
}

output "name" {
  description = "Имя DNS зоны"
  value       = yandex_dns_zone.this.name
}

output "zone" {
  description = "DNS зона"
  value       = yandex_dns_zone.this.zone
}

output "records" {
  description = "DNS записи"

  value = {
    for key, record in yandex_dns_recordset.this :
    key => {
      id   = record.id
      name = record.name
      type = record.type
      ttl  = record.ttl
      data = record.data
    }
  }
}