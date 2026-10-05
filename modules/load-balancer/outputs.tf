# NETWORK LOAD BALANCER
output "network_load_balancer" {
  description = "Network Load Balancer"

  value = var.network_load_balancer_enabled ? {
    id = yandex_lb_network_load_balancer.var_input[0].id

    name = yandex_lb_network_load_balancer.var_input[0].name

    ip = try(
      one(
        one(yandex_lb_network_load_balancer.var_input[0].listener)
        .external_address_spec
      ).address,
      null
    )
  } : null
}

# APPLICATION LOAD BALANCER
output "application_load_balancer" {
  description = "Application Load Balancer"
  value = var.application_load_balancer_enabled ? {
    id = (
      yandex_alb_load_balancer.var_input[0].id
    )
    name = (
      yandex_alb_load_balancer.var_input[0].name
    )
    ip = try(
      yandex_alb_load_balancer.var_input[0]
      .listener[0]
      .endpoint[0]
      .address[0]
      .external_ipv4_address[0]
      .address,
      null
    )
  } : null
}