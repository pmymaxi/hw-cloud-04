output "service_accounts" {
  description = "Созданные сервисные аккаунты"

  value = {
    for key, sa in yandex_iam_service_account.this : key => {
      id   = sa.id
      name = sa.name
    }
  }
}