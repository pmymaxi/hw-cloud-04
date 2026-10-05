resource "yandex_mdb_mysql_cluster" "this" {
  name                = var.mysql.name
  environment         = var.mysql.environment
  network_id          = var.mysql.network_id
  version             = var.mysql.version
  deletion_protection = var.mysql.deletion_protection

  resources {
    resource_preset_id = var.mysql.resource_preset_id
    disk_type_id       = var.mysql.disk_type_id
    disk_size          = var.mysql.disk_size
  }

  backup_window_start {
    hours   = var.mysql.backup_window_start.hours
    minutes = var.mysql.backup_window_start.minutes
  }

  maintenance_window {
    type = var.mysql.maintenance_window.type
    day  = var.mysql.maintenance_window.day
    hour = var.mysql.maintenance_window.hour
  }

  dynamic "host" {
    for_each = var.mysql.hosts

    content {
      zone             = host.value.zone
      subnet_id        = host.value.subnet_id
      assign_public_ip = host.value.assign_public_ip
      priority         = host.value.priority
    }
  }
}

resource "yandex_mdb_mysql_database" "this" {
  cluster_id = yandex_mdb_mysql_cluster.this.id
  name       = var.mysql.database.name
}

resource "yandex_mdb_mysql_user" "this" {
  cluster_id = yandex_mdb_mysql_cluster.this.id
  name       = var.mysql.user.name
  password   = var.mysql.user.password

  permission {
    database_name = yandex_mdb_mysql_database.this.name
    roles         = ["ALL"]
  }
}