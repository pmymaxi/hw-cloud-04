resource "yandex_kubernetes_cluster" "this" {
  name        = var.kubernetes.name
  description = var.kubernetes.description

  folder_id  = var.kubernetes.folder_id
  network_id = var.kubernetes.network_id

  cluster_ipv4_range = var.kubernetes.cluster_ipv4_range
  service_ipv4_range = var.kubernetes.service_ipv4_range

  release_channel = var.kubernetes.release_channel

  service_account_id      = var.kubernetes.service_account_id
  node_service_account_id = var.kubernetes.node_service_account_id

  kms_provider {
    key_id = var.kubernetes.kms_key_id
  }

  master {
    version   = var.kubernetes.version
    public_ip = var.kubernetes.public_ip

    regional {
      region = "ru-central1"

      dynamic "location" {
        for_each = var.kubernetes.master_locations

        content {
          zone      = location.value.zone
          subnet_id = location.value.subnet_id
        }
      }
    }

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "03:00"
        duration   = "3h"
      }
    }
  }
}

resource "yandex_kubernetes_node_group" "this" {
  cluster_id  = yandex_kubernetes_cluster.this.id
  name        = var.kubernetes.node_group.name
  description = var.kubernetes.node_group.description

  version = var.kubernetes.node_group.version

  scale_policy {
    auto_scale {
      min     = var.kubernetes.node_group.min_size
      max     = var.kubernetes.node_group.max_size
      initial = var.kubernetes.node_group.min_size
    }
  }

  instance_template {
    platform_id = var.kubernetes.node_group.platform_id

    resources {
      cores         = var.kubernetes.node_group.cores
      memory        = var.kubernetes.node_group.memory
      core_fraction = var.kubernetes.node_group.core_fraction
    }

    boot_disk {
      type = var.kubernetes.node_group.boot_disk_type
      size = var.kubernetes.node_group.boot_disk_size
    }

    network_interface {
      nat = var.kubernetes.node_group.nat

      subnet_ids = [
        for location in var.kubernetes.node_group.locations :
        location.subnet_id
      ]
    }

    scheduling_policy {
      preemptible = false
    }
  }

  dynamic "allocation_policy" {
    for_each = [1]

    content {
      dynamic "location" {
        for_each = var.kubernetes.node_group.locations

        content {
          zone = location.value.zone
        }
      }
    }
  }

  maintenance_policy {
    auto_repair  = true
    auto_upgrade = true

    maintenance_window {
      start_time = "03:00"
      duration   = "3h"
    }
  }

  deploy_policy {
    max_expansion   = 1
    max_unavailable = 0
  }

  depends_on = [
    yandex_kubernetes_cluster.this
  ]
}