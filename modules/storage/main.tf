# SERVICE ACCOUNT
resource "yandex_iam_service_account" "var_input" {
  for_each  = var.service_account
  name      = each.value.name
  folder_id = var.folder_id
}

# SERVICE ACCOUNT IAM
resource "yandex_resourcemanager_folder_iam_member" "var_input" {
  for_each = {
    for key, service_account in var.service_account :
    key => service_account
    if service_account.role != null
  }

  folder_id = var.folder_id
  role      = each.value.role

  member = "serviceAccount:${yandex_iam_service_account.var_input[each.key].id}"
}

# STATIC ACCESS KEY
resource "yandex_iam_service_account_static_access_key" "var_input" {
  for_each = {
    for key, service_account in var.service_account :
    key => service_account
    if service_account.desc_key != null
  }
  service_account_id = yandex_iam_service_account.var_input[each.key].id
  description        = each.value.desc_key
}

# KMS SYMMETRIC KEY
resource "yandex_kms_symmetric_key" "var_input" {
  for_each = var.kms_key

  name              = each.value.name
  description       = each.value.description
  default_algorithm = each.value.default_algorithm
  rotation_period   = each.value.rotation_period
}

# KMS ACCESS
resource "yandex_kms_symmetric_key_iam_binding" "var_input" {
  for_each = local.kms_service_accounts

  symmetric_key_id = yandex_kms_symmetric_key.var_input[each.value.kms_key].id
  role             = "kms.keys.encrypterDecrypter"
  members          = ["serviceAccount:${yandex_iam_service_account.var_input[each.value.service_account].id}"]
}

# OBJECT STORAGE BUCKET
resource "yandex_storage_bucket" "var_input" {
  for_each = var.bucket

  bucket     = each.key
  max_size   = each.value.max_size
  access_key = yandex_iam_service_account_static_access_key.var_input["admin"].access_key
  secret_key = yandex_iam_service_account_static_access_key.var_input["admin"].secret_key

  versioning {
    enabled = each.value.versioning
  }

  anonymous_access_flags {
    read        = each.value.anonymous_access.read
    list        = each.value.anonymous_access.list
    config_read = each.value.anonymous_access.config_read
  }

  dynamic "server_side_encryption_configuration" {
    for_each = each.value.encryption != null ? [each.value.encryption] : []

    content {
      rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = yandex_kms_symmetric_key.var_input[
            server_side_encryption_configuration.value.kms_key
          ].id

          sse_algorithm = server_side_encryption_configuration.value.sse_algorithm
        }
      }
    }
  }

  dynamic "website" {
    for_each = each.value.website != null ? [each.value.website] : []

    content {
      index_document = website.value.index_document
      error_document = try(website.value.error_document, null)
    }
  }

  dynamic "https" {
    for_each = each.value.https != null ? [each.value.https] : []

    content {
      certificate_id = https.value.certificate_id
    }
  }
}

# OBJECT STORAGE OBJECT - SOURCE
resource "yandex_storage_object" "source" {
  for_each = {
    for key, object in local.storage_object :
    key => object
    if object.source != null
  }

  depends_on = [yandex_storage_bucket.var_input]

  bucket     = each.value.bucket
  key        = each.value.key
  source     = "${path.root}${each.value.source}"
  access_key = yandex_iam_service_account_static_access_key.var_input["admin"].access_key
  secret_key = yandex_iam_service_account_static_access_key.var_input["admin"].secret_key
  acl        = each.value.public ? "public-read" : "private"
  tags       = each.value.tags
}

# OBJECT STORAGE OBJECT - CONTENT
resource "yandex_storage_object" "content" {
  for_each = {
    for key, object in local.storage_object :
    key => object
    if object.source == null && object.content != null
  }

  depends_on = [yandex_storage_bucket.var_input]

  bucket     = each.value.bucket
  key        = each.value.key
  content    = each.value.content
  access_key = yandex_iam_service_account_static_access_key.var_input["admin"].access_key
  secret_key = yandex_iam_service_account_static_access_key.var_input["admin"].secret_key
  acl        = each.value.public ? "public-read" : "private"
  tags       = each.value.tags
}

# BUCKET IAM
resource "yandex_storage_bucket_iam_binding" "var_input" {
  for_each = local.bucket_access

  bucket  = yandex_storage_bucket.var_input[each.key].bucket
  role    = each.value.role
  members = ["serviceAccount:${yandex_iam_service_account.var_input[each.value.service_account].id}"]
}