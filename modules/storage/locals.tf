locals {

  # Объекты для загрузки в Object Storage
  storage_object = merge([
    for bucket_name, bucket in var.bucket : {
      for object_key, object in bucket.objects :

      "${bucket_name}.${object_key}" => merge(
        object,
        {
          bucket = bucket_name
        }
      )
    }
  ]...)

  # Bucket, использующие KMS
  bucket_encryption = {
    for bucket_name, bucket in var.bucket :
    bucket_name => bucket.encryption
    if bucket.encryption != null
  }

  # Bucket IAM
  bucket_access = {
    for bucket_name, bucket in var.bucket :
    bucket_name => bucket.access
    if bucket.access != null
  }

  # Связь KMS -> Service Account
  kms_service_accounts = merge([
    for kms_key_name, kms_key in var.kms_key : {
      for service_account_name in kms_key.service_accounts :
      "${kms_key_name}.${service_account_name}" => {
        kms_key         = kms_key_name
        service_account = service_account_name
      }
    }
  ]...)
}