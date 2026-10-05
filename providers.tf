terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "= 0.202.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
  }

  required_version = "~> 1.12.0"
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = file("~/.ssh/sa_key_yc.json")
}

provider "kubernetes" {
  host = module.kubernetes.cluster_endpoint

  cluster_ca_certificate = module.kubernetes.cluster_ca_certificate

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "yc"

    args = [
      "managed-kubernetes",
      "create-token"
    ]
  }
}