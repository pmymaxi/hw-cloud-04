resource "yandex_iam_service_account" "this" {
  for_each = var.service_account

  name        = each.value.name
  description = each.value.description
}

resource "yandex_resourcemanager_folder_iam_member" "this" {
  for_each = {
    for item in flatten([
      for sa_key, sa in var.service_account : [
        for role in sa.roles : {
          key         = "${sa_key}.${role}"
          service_acc = sa_key
          role        = role
        }
      ]
    ]) : item.key => item
  }

  folder_id = var.folder_id
  role      = each.value.role
  member    = "serviceAccount:${yandex_iam_service_account.this[each.value.service_acc].id}"
}