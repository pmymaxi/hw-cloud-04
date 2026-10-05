vpc_network = {
  develop = {
    name = "network-hw-cloud"

    labels = {
      network = "develop"
    }
  }
}

gateway = {
  develop = {
    name = "nat-gateway"
  }
}

vpc_subnet = {
  develop = {
    public = {
      description = "Публичная подсеть"

      labels = {
        subnet = "public"
      }

      zone           = "ru-central1-a"
      v4_cidr_blocks = "192.168.10.0/24"
      route_table    = "k8s"
    }

    private = {
      description = "Приватная подсеть"

      labels = {
        subnet = "private"
      }

      zone           = "ru-central1-a"
      v4_cidr_blocks = "192.168.20.0/24"
      route_table    = "private"
    }

    mysql-b = {
      description = "Private subnet for MySQL"

      labels = {
        subnet = "mysql-b"
      }

      zone           = "ru-central1-b"
      v4_cidr_blocks = "192.168.30.0/24"
    }

    mysql-d = {
      description = "Private subnet for MySQL"

      labels = {
        subnet = "mysql-d"
      }

      zone           = "ru-central1-d"
      v4_cidr_blocks = "192.168.40.0/24"
    }

    k8s-b = {
      description = "Public subnet for Kubernetes"

      labels = {
        subnet = "k8s-b"
      }

      zone           = "ru-central1-b"
      v4_cidr_blocks = "192.168.50.0/24"
    }

    k8s-d = {
      description = "Public subnet for Kubernetes"

      labels = {
        subnet = "k8s-d"
      }

      zone           = "ru-central1-d"
      v4_cidr_blocks = "192.168.60.0/24"
    }
  }
}

route_table = {
  develop = {
    private = {
      labels = {
        route_table = "private"
      }

      static_route = {
        destination_prefix = "0.0.0.0/0"
        next_hop_address   = "192.168.10.254"
      }
    }

    k8s = {
      labels = {
        route_table = "k8s"
      }

      static_route = {
        destination_prefix = "0.0.0.0/0"
        gateway            = "develop"
      }
    }
  }
}