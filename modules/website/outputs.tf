output "certificate_id" {
  description = "ID сертификата Yandex Certificate Manager"
  value       = yandex_cm_certificate.website.id
}

output "certificate_name" {
  description = "Имя сертификата"
  value       = yandex_cm_certificate.website.name
}

output "certificate_status" {
  description = "Статус сертификата"
  value       = yandex_cm_certificate.website.status
}

output "domain" {
  description = "Домен сертификата"
  value       = var.domain
}

output "challenges" {
  description = "DNS challenges для подтверждения домена"
  value       = yandex_cm_certificate.website.challenges
}

output "certificate_challenge" {
  description = "DNS challenge сертификата"
  value = {
    name  = yandex_cm_certificate.website.challenges[0].dns_name
    type  = yandex_cm_certificate.website.challenges[0].dns_type
    value = yandex_cm_certificate.website.challenges[0].dns_value
  }
}