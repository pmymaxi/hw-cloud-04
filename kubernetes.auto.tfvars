kubernetes = {
  name        = "k8s-netology"
  description = "Managed Kubernetes cluster for Netology homework"
  network_id  = "enpi1glptt1tt9c20vqk"

  cluster_ipv4_range = "10.100.0.0/16"
  service_ipv4_range = "10.110.0.0/16"

  release_channel = "STABLE"
  version         = "1.35"

  public_ip = true

  kms_key_id = "abjt8ch1utg6anc53cf0"

  master_locations = [
    {
      zone      = "ru-central1-a"
      subnet_id = "e9bkua8d581hn5dfio8v"
    },
    {
      zone      = "ru-central1-b"
      subnet_id = "e2lhqku1lh6ongflvdlk"
    },
    {
      zone      = "ru-central1-d"
      subnet_id = "fl85snab6vgum9e37njk"
    }
  ]

  node_group = {
    name        = "k8s-nodes"
    description = "Kubernetes worker nodes"
    version     = "1.35"

    min_size = 3
    max_size = 6

    platform_id   = "standard-v2"
    cores         = 2
    memory        = 4
    core_fraction = 100

    boot_disk_type = "network-hdd"
    boot_disk_size = 64

    # Worker-ноды без публичных IP.
    # Интернет через Yandex Cloud NAT Gateway.
    nat = false

    locations = [
      {
        zone      = "ru-central1-a"
        subnet_id = "e9bkua8d581hn5dfio8v"
      }
    ]
  }
}