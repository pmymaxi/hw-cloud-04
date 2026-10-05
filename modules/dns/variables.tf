variable "folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
}

variable "zone_name" {
  description = "Имя DNS зоны"
  type        = string
}

variable "zone" {
  description = "DNS зона"
  type        = string
}

variable "public" {
  description = "Публичная DNS зона"
  type        = bool
  default     = true
}

variable "records" {
  description = "DNS записи"

  type = map(object({
    name        = string
    type        = string
    ttl         = number
    data        = list(string)
    description = optional(string)
  }))

  default = {}
}