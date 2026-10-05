# =========================================================
# COMMON
# =========================================================

variable "folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
}


# =========================================================
# NETWORK LOAD BALANCER
# =========================================================

variable "network_load_balancer_enabled" {
  description = "Включить Network Load Balancer"
  type        = bool
}

variable "network_load_balancer_name" {
  description = "Имя Network Load Balancer"
  type        = string
}

variable "network_load_balancer_target_group_id" {
  description = "ID Target Group Instance Group для NLB"
  type        = string
}

variable "network_load_balancer_listener" {
  description = "Настройки listener NLB"

  type = object({
    name        = string
    port        = number
    target_port = number
    protocol    = string
    ip_version  = string
  })
}

variable "network_load_balancer_healthcheck" {
  description = "Health check NLB"

  type = object({
    name                = string
    interval            = number
    timeout             = number
    unhealthy_threshold = number
    healthy_threshold   = number

    http_options = object({
      port = number
      path = string
    })
  })
}


# =========================================================
# APPLICATION LOAD BALANCER
# =========================================================

variable "application_load_balancer_enabled" {
  description = "Включить Application Load Balancer"
  type        = bool
}

variable "application_load_balancer_name" {
  description = "Имя Application Load Balancer"
  type        = string
}

variable "application_load_balancer_target_group_id" {
  description = "ID Target Group Instance Group для ALB"
  type        = string
}

variable "application_load_balancer_network_id" {
  description = "ID VPC сети ALB"
  type        = string
}

variable "application_load_balancer_zone" {
  description = "Зона ALB"
  type        = string
}

variable "application_load_balancer_subnet_id" {
  description = "ID подсети ALB"
  type        = string
}

variable "application_load_balancer_http_router" {
  description = "HTTP Router ALB"

  type = object({
    name = string
  })
}

variable "application_load_balancer_backend" {
  description = "Backend Group ALB"

  type = object({
    name         = string
    backend_name = string
    port         = number
    weight       = number

    healthcheck = object({
      timeout             = string
      interval            = string
      healthy_threshold   = number
      unhealthy_threshold = number
      healthcheck_port    = number

      http_healthcheck = object({
        path = string
      })
    })
  })
}

variable "application_load_balancer_virtual_host" {
  description = "Virtual Host ALB"

  type = object({
    name = string

    route = object({
      name    = string
      timeout = string
    })
  })
}

variable "application_load_balancer_listener" {
  description = "Listener ALB"

  type = object({
    name = string
    port = number
  })
}