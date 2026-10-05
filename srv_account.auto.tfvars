service_account = {
  admin = {
    name        = "sa-admin-s3"
    description = "Service account for Object Storage"
    roles = ["storage.admin"]
  }

  k8s = {
    name        = "sa-k8s"
    description = "Service account for Managed Kubernetes cluster"

    roles = [
      "k8s.clusters.agent",
      "vpc.publicAdmin",
      "kms.keys.encrypterDecrypter",
      "load-balancer.admin"
    ]
  }

  k8s-node = {
    name        = "sa-k8s-node"
    description = "Service account for Managed Kubernetes nodes"

    roles = ["container-registry.images.puller"]
  }
}