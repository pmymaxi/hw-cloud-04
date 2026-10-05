resource "yandex_cm_certificate" "website" {
  name    = var.certificate_name
  domains = [var.domain]
  managed { challenge_type = "DNS_CNAME" }
}