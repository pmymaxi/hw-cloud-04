# INSTANCE GROUP
resource "yandex_compute_instance_group" "var_input" {
  name               = var.name
  folder_id          = var.folder_id
  service_account_id = var.service_account_id

  # INSTANCE TEMPLATE
  instance_template {
    platform_id = var.platform_id

    # RESOURCES
    resources {
      cores         = var.cores
      memory        = var.memory
      core_fraction = var.core_fraction
    }

    # BOOT DISK
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.image_id
        size     = var.disk_size
        type     = var.disk_type
      }
    }

    # NETWORK
    network_interface {
      subnet_ids = [var.subnet_id]
      nat        = var.network_nat
    }

    # SCHEDULING
    scheduling_policy {
      preemptible = var.preemptible
    }

    # METADATA
    metadata = {
      ssh-keys  = "${var.ssh_user}:${var.ssh_public_key}"
      user-data = var.user_data
    }
  }

  # NETWORK LOAD BALANCER INTEGRATION
  dynamic "load_balancer" {
    for_each = var.network_load_balancer.enabled ? [1] : []
    content {
      target_group_name        = var.network_load_balancer.target_group_name
      target_group_description = var.network_load_balancer.target_group_description
    }
  }

  # APPLICATION LOAD BALANCER INTEGRATION
  dynamic "application_load_balancer" {
    for_each = var.application_load_balancer.enabled ? [1] : []
    content {
      target_group_name        = var.application_load_balancer.target_group_name
      target_group_description = var.application_load_balancer.target_group_description
    }
  }

  # FIXED SIZE
  scale_policy {
    fixed_scale {
      size = var.instance_count
    }
  }

  # ALLOCATION
  allocation_policy {
    zones = [var.zone]
  }

  # DEPLOY POLICY
  deploy_policy {
    max_unavailable = var.deploy_policy.max_unavailable
    max_expansion   = var.deploy_policy.max_expansion
    strategy        = var.deploy_policy.strategy
  }

  # HEALTH CHECK
  health_check {
    interval            = var.health_check.interval
    timeout             = var.health_check.timeout
    unhealthy_threshold = var.health_check.unhealthy_threshold
    healthy_threshold   = var.health_check.healthy_threshold
    tcp_options {
      port = var.health_check.port
    }
  }
}