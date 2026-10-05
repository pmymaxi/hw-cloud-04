output "id" {
  description = "ID Instance Group"

  value = yandex_compute_instance_group.var_input.id
}

output "name" {
  description = "Имя Instance Group"

  value = yandex_compute_instance_group.var_input.name
}

output "status" {
  description = "Статус Instance Group"

  value = yandex_compute_instance_group.var_input.status
}

output "instances" {
  description = "Экземпляры Instance Group"

  value = yandex_compute_instance_group.var_input.instances
}

output "network_load_balancer" {
  description = "Информация об интеграции с Network Load Balancer"

  value = try(
    {
      target_group_id   = yandex_compute_instance_group.var_input.load_balancer[0].target_group_id
      target_group_name = yandex_compute_instance_group.var_input.load_balancer[0].target_group_name
    },
    null
  )
}

output "application_load_balancer" {
  description = "Информация об интеграции с Application Load Balancer"

  value = try(
    {
      target_group_id   = yandex_compute_instance_group.var_input.application_load_balancer[0].target_group_id
      target_group_name = yandex_compute_instance_group.var_input.application_load_balancer[0].target_group_name
    },
    null
  )
}