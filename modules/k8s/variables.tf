variable "kubernetes" {
  description = "Параметры Managed Kubernetes"

  type = object({
    name                    = string
    description             = optional(string, "")
    folder_id               = string
    network_id              = string
    service_account_id      = string
    node_service_account_id = string

    cluster_ipv4_range = string
    service_ipv4_range = string

    release_channel = string
    version         = string

    public_ip = bool

    kms_key_id = string

    master_locations = list(object({
      zone      = string
      subnet_id = string
    }))

    node_group = object({
      name        = string
      description = optional(string, "")
      version     = string

      min_size = number
      max_size = number

      platform_id   = string
      cores         = number
      memory        = number
      core_fraction = number

      boot_disk_type = string
      boot_disk_size = number

      nat = bool

      locations = list(object({
        zone      = string
        subnet_id = string
      }))
    })
  })
}