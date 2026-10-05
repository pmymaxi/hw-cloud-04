variable "folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
}

variable "service_account" {
  description = "Сервисные аккаунты Yandex Cloud"

  type = map(object({
    name        = string
    description = optional(string, "")
    roles       = optional(list(string), [])
  }))

  default = {}
}