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
  type = map(list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  })))
  default     = {}
  description = "Блок конфигурации правил входящих соединений в группе безопасности"
}

variable "security_group_egress" {
  type = map(list(object(
    {
      protocol       = string
      description    = string
      v4_cidr_blocks = list(string)
      port           = optional(number)
      from_port      = optional(number)
      to_port        = optional(number)
  })))
  default     = {}
  description = "Блок конфигурации правил исходящих соединений в группе безопасности"
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
      next_hop_address   = optional(string)
      gateway            = optional(string)
    })
  })))
  default = {}
}