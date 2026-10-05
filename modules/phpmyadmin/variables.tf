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