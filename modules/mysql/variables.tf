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