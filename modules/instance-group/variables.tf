variable "name" {
  description = "Имя Instance Group"
  type        = string
}

variable "folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
}

variable "service_account_id" {
  description = "ID сервисного аккаунта Instance Group"
  type        = string
}

variable "platform_id" {
  description = "Platform ID виртуальных машин"
  type        = string
}

variable "cores" {
  description = "Количество CPU"
  type        = number
}

variable "memory" {
  description = "Объём RAM в GB"
  type        = number
}

variable "core_fraction" {
  description = "Гарантированная доля CPU"
  type        = number
}

variable "image_id" {
  description = "ID образа виртуальной машины"
  type        = string
}

variable "disk_size" {
  description = "Размер загрузочного диска в GB"
  type        = number
}

variable "disk_type" {
  description = "Тип загрузочного диска"
  type        = string
}


variable "subnet_id" {
  description = "ID подсети Instance Group"
  type        = string
}

variable "network_nat" {
  description = "Назначать публичный IP через NAT"
  type        = bool
}

variable "preemptible" {
  description = "Использовать прерываемые виртуальные машины"
  type        = bool
}

variable "ssh_user" {
  description = "Пользователь SSH"
  type        = string
}

variable "ssh_public_key" {
  description = "Публичный SSH ключ"
  type        = string
}

variable "user_data" {
  description = "Cloud-init user-data"
  type        = string
}

variable "instance_count" {
  description = "Количество экземпляров Instance Group"
  type        = number
}

variable "zone" {
  description = "Зона размещения Instance Group"
  type        = string
}

variable "deploy_policy" {
  description = "Политика развёртывания Instance Group"

  type = object({
    max_unavailable = number
    max_expansion   = number
    strategy        = string
  })
}

variable "health_check" {
  description = "Health check Instance Group"

  type = object({
    interval            = number
    timeout             = number
    unhealthy_threshold = number
    healthy_threshold   = number
    port                = number
  })
}

variable "network_load_balancer" {
  description = "Интеграция Instance Group с Network Load Balancer"

  type = object({
    enabled                  = bool
    target_group_name        = string
    target_group_description = string
  })
}

variable "application_load_balancer" {
  description = "Интеграция Instance Group с Application Load Balancer"

  type = object({
    enabled                  = bool
    target_group_name        = string
    target_group_description = string
  })
}