mysql = {
  name                = "mysql-netology"
  environment         = "PRESTABLE"
  version             = "8.0"
  deletion_protection = true

  network_id = "enpi1glptt1tt9c20vqk"

  resource_preset_id = "b2.medium"
  disk_type_id       = "network-ssd"
  disk_size          = 20

  backup_window_start = {
    hours   = 23
    minutes = 59
  }

  maintenance_window = {
    type = "WEEKLY"
    day  = "SUN"
    hour = 3
  }

  hosts = [
    {
      zone             = "ru-central1-a"
      subnet_id        = "e9bkot2uq4bcvd6metvm"
      assign_public_ip = false
    },
    {
      zone             = "ru-central1-b"
      subnet_id        = "e2lpcmnun9dnirsct23c"
      assign_public_ip = false
    },
    {
      zone             = "ru-central1-d"
      subnet_id        = "fl8j0kh2k2pghrg66b1s"
      assign_public_ip = false
    }
  ]

  database = {
    name = "netology_db"
  }

  user = {
    name     = "netology"
    password = "netology"
  }
}