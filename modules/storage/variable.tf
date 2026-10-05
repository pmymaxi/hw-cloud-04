variable "folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
}

variable "service_account" {
  description = "Сервисные аккаунты"

  type = map(object({
    name     = string
    role     = optional(string)
    desc_key = optional(string)
  }))

  default = {}
}

variable "kms_key" {
  description = "KMS ключи для шифрования bucket"

  type = map(object({
    name              = string
    description       = optional(string, "")
    default_algorithm = optional(string, "AES_128")
    rotation_period   = optional(string)
    service_accounts  = optional(list(string), [])
  }))

  default = {}
}

variable "bucket" {
  description = "Yandex Object Storage buckets"

  type = map(object({
    max_size   = optional(number)
    versioning = optional(bool, false)

    anonymous_access = optional(object({
      read        = optional(bool, false)
      list        = optional(bool, false)
      config_read = optional(bool, false)
    }), {})

    encryption = optional(object({
      kms_key       = string
      sse_algorithm = optional(string, "aws:kms")
    }))

    website = optional(object({
      index_document = string
      error_document = optional(string)
    }))

    https = optional(object({
      certificate_id = string
    }))

    objects = optional(map(object({
      key     = string
      source  = optional(string)
      content = optional(string)
      tags    = optional(map(string), {})
      public  = optional(bool, false)
    })), {})

    access = optional(object({
      service_account = string
      role            = optional(string, "storage.viewer")
    }))
  }))

  default = {}
}
