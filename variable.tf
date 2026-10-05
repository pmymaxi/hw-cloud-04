variable "access_key" {
  type        = string
  default     = null
  sensitive   = true
  description = "Access key сервисного аккаунта"
}

variable "secret_key" {
  type        = string
  default     = null
  sensitive   = true
  description = "Secret key сервисного аккаунта"
}

variable "cloud_id" {
  type        = string
  description = "ID облака Yandex Cloud"
}

variable "folder_id" {
  type        = string
  description = "ID каталога Yandex Cloud"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона по умолчанию"
}

# ============================================================
# VPC
# ============================================================

variable "vpc_network" {
  description = "Облачные сети"

  type = map(object({
    name        = string
    description = optional(string)
    labels      = optional(map(string), {})
  }))

  default = {}
}

variable "vpc_subnet" {
  description = "Подсети облачных сетей"

  type = map(map(object({
    description    = optional(string)
    labels         = optional(map(string), {})
    zone           = string
    v4_cidr_blocks = string
    route_table    = optional(string)
  })))

  default = {}
}

variable "gateway" {
  description = "Gateway"

  type = map(object({
    name   = string
    labels = optional(map(string), {})
  }))

  default = {}
}

variable "route_table" {
  description = "Таблицы маршрутизации"

  type = map(map(object({
    labels = optional(map(string), {})

    static_route = object({
      destination_prefix = string
      gateway            = optional(string)
      next_hop_address   = optional(string)
    })
  })))

  default = {}
}

variable "security_group" {
  description = "Группы безопасности"

  type = map(object({
    name        = string
    description = optional(string)
    labels      = optional(map(string), {})
  }))

  default = {}
}

variable "security_group_ingress" {
  description = "Правила входящих соединений"

  type = map(list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = optional(number)
    from_port      = optional(number)
    to_port        = optional(number)
  })))

  default = {}
}

variable "security_group_egress" {
  description = "Правила исходящих соединений"

  type = map(list(object({
    protocol       = string
    description    = string
    v4_cidr_blocks = list(string)
    port           = optional(number)
    from_port      = optional(number)
    to_port        = optional(number)
  })))

  default = {}
}

# ============================================================
# Service Accounts
# ============================================================

variable "service_account" {
  description = "Сервисные аккаунты Yandex Cloud"

  type = map(object({
    name        = string
    description = optional(string, "")
    roles       = optional(list(string), [])
  }))

  default = {}
}

# ============================================================
# KMS
# ============================================================

variable "kms_key" {
  description = "KMS ключи"

  type = map(object({
    name              = string
    description       = optional(string, "")
    default_algorithm = optional(string, "AES_128")
    rotation_period   = optional(string)
    service_accounts  = optional(list(string), [])
  }))

  default = {}
}

variable "mysql" {
  description = "Параметры Managed MySQL"

  sensitive = true

  type = object({
    name                = string
    environment         = string
    version             = string
    deletion_protection = bool

    network_id = string

    resource_preset_id = string
    disk_type_id       = string
    disk_size          = number

    backup_window_start = object({
      hours   = number
      minutes = number
    })

    maintenance_window = object({
      type = string
      day  = optional(string)
      hour = optional(number)
    })

    hosts = list(object({
      zone             = string
      subnet_id        = string
      assign_public_ip = optional(bool, false)
      priority         = optional(number)
    }))

    database = object({
      name = string
    })

    user = object({
      name     = string
      password = string
    })
  })
}

variable "kubernetes" {
  description = "Параметры Managed Kubernetes"

  type = object({
    name        = string
    description = optional(string, "")
    network_id  = string

    cluster_ipv4_range = string
    service_ipv4_range = string

    release_channel = string
    version         = string

    public_ip = bool

    kms_key_id = string

    master_locations = list(object({
      zone      = string
      subnet_id = string
    }))

    node_group = object({
      name        = string
      description = optional(string, "")
      version     = string

      min_size = number
      max_size = number

      platform_id   = string
      cores         = number
      memory        = number
      core_fraction = number

      boot_disk_type = string
      boot_disk_size = number

      nat = bool

      locations = list(object({
        zone      = string
        subnet_id = string
      }))
    })
  })
}

variable "phpmyadmin" {
  description = "Параметры phpMyAdmin"

  type = object({
    name      = string
    namespace = string
    image     = string

    mysql = object({
      host     = string
      port     = number
      database = string
      user     = string
      password = string
    })

    service = object({
      type        = string
      port        = number
      target_port = number
    })

    replicas = number
  })

  sensitive = true
}