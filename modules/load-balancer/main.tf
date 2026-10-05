# NETWORK LOAD BALANCER
resource "yandex_lb_network_load_balancer" "var_input" {
  count     = var.network_load_balancer_enabled ? 1 : 0
  name      = var.network_load_balancer_name
  folder_id = var.folder_id

  # LISTENER
  listener {
    name        = var.network_load_balancer_listener.name
    port        = var.network_load_balancer_listener.port
    target_port = var.network_load_balancer_listener.target_port
    protocol    = var.network_load_balancer_listener.protocol
    external_address_spec {
      ip_version = var.network_load_balancer_listener.ip_version
    }
  }

  # TARGET GROUP
  attached_target_group {
    target_group_id = var.network_load_balancer_target_group_id

    # HEALTH CHECK
    healthcheck {
      name                = var.network_load_balancer_healthcheck.name
      interval            = var.network_load_balancer_healthcheck.interval
      timeout             = var.network_load_balancer_healthcheck.timeout
      unhealthy_threshold = (var.network_load_balancer_healthcheck.unhealthy_threshold)
      healthy_threshold   = (var.network_load_balancer_healthcheck.healthy_threshold)

      http_options {
        port = (var.network_load_balancer_healthcheck.http_options.port)
        path = (var.network_load_balancer_healthcheck.http_options.path)
      }
    }
  }
}

# APPLICATION LOAD BALANCER
resource "yandex_alb_http_router" "var_input" {
  count     = var.application_load_balancer_enabled ? 1 : 0
  name      = var.application_load_balancer_http_router.name
  folder_id = var.folder_id
}

# ALB BACKEND GROUP
resource "yandex_alb_backend_group" "var_input" {
  count     = var.application_load_balancer_enabled ? 1 : 0
  name      = var.application_load_balancer_backend.name
  folder_id = var.folder_id
  http_backend {
    name             = var.application_load_balancer_backend.backend_name
    port             = var.application_load_balancer_backend.port
    weight           = var.application_load_balancer_backend.weight
    target_group_ids = [var.application_load_balancer_target_group_id]

    # HEALTH CHECK
    healthcheck {
      timeout             = (var.application_load_balancer_backend.healthcheck.timeout)
      interval            = (var.application_load_balancer_backend.healthcheck.interval)
      healthy_threshold   = (var.application_load_balancer_backend.healthcheck.healthy_threshold)
      unhealthy_threshold = (var.application_load_balancer_backend.healthcheck.unhealthy_threshold)
      healthcheck_port    = (var.application_load_balancer_backend.healthcheck.healthcheck_port)
      http_healthcheck {
        path = (
          var.application_load_balancer_backend
          .healthcheck
          .http_healthcheck
          .path
        )
      }
    }
  }
}

# ALB VIRTUAL HOST
resource "yandex_alb_virtual_host" "var_input" {
  count          = var.application_load_balancer_enabled ? 1 : 0
  name           = var.application_load_balancer_virtual_host.name
  http_router_id = yandex_alb_http_router.var_input[0].id
  route {
    name = var.application_load_balancer_virtual_host.route.name
    http_route {
      http_route_action {
        backend_group_id = (yandex_alb_backend_group.var_input[0].id)
        timeout          = (var.application_load_balancer_virtual_host.route.timeout)
      }
    }
  }
}

# APPLICATION LOAD BALANCER
resource "yandex_alb_load_balancer" "var_input" {
  count      = var.application_load_balancer_enabled ? 1 : 0
  name       = var.application_load_balancer_name
  folder_id  = var.folder_id
  network_id = var.application_load_balancer_network_id

  # ALLOCATION
  allocation_policy {
    location {
      zone_id   = var.application_load_balancer_zone
      subnet_id = var.application_load_balancer_subnet_id
    }
  }

  # HTTP LISTENER
  listener {
    name = var.application_load_balancer_listener.name
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [var.application_load_balancer_listener.port]
    }
    http {
      handler {
        http_router_id = (yandex_alb_http_router.var_input[0].id)
      }
    }
  }
}