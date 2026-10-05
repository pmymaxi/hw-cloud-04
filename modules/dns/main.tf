resource "yandex_dns_zone" "this" {
  folder_id = var.folder_id
  name      = var.zone_name
  zone      = var.zone
  public    = var.public
}

resource "yandex_dns_recordset" "this" {
  for_each = var.records

  zone_id     = yandex_dns_zone.this.id
  name        = each.value.name
  type        = each.value.type
  ttl         = each.value.ttl
  data        = each.value.data
  description = each.value.description
}