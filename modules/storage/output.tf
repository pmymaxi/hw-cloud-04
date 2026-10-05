output "service_account" {
  description = "Созданные сервисные аккаунты"

  value = {
    for key, service_account in yandex_iam_service_account.var_input :
    key => {
      id   = service_account.id
      name = service_account.name
    }
  }
}


output "access_keys" {
  description = "Static access keys сервисных аккаунтов"

  sensitive = true

  value = {
    for key, access_key in yandex_iam_service_account_static_access_key.var_input :
    key => {
      access_key = access_key.access_key
      secret_key = access_key.secret_key
    }
  }
}


output "kms" {
  description = "Созданные KMS ключи"

  value = {
    for key, kms in yandex_kms_symmetric_key.var_input :
    key => {
      id   = kms.id
      name = kms.name
    }
  }
}


output "bucket" {
  description = "Созданные Object Storage buckets"

  value = {
    for key, bucket in yandex_storage_bucket.var_input :
    key => {
      bucket             = bucket.bucket
      bucket_domain_name = bucket.bucket_domain_name
    }
  }
}


output "objects" {
  description = "Загруженные Object Storage objects"

  value = merge(
    {
      for key, object in yandex_storage_object.source :
      key => {
        bucket = object.bucket
        key    = object.key
        acl    = object.acl
      }
    },
    {
      for key, object in yandex_storage_object.content :
      key => {
        bucket = object.bucket
        key    = object.key
        acl    = object.acl
      }
    }
  )
}