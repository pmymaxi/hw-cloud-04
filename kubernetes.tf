module "kubernetes" {
  source = "./modules/k8s"

  kubernetes = merge(
    var.kubernetes,
    {
      folder_id = var.folder_id
      service_account_id = module.service_account.service_accounts["k8s"].id
      node_service_account_id = module.service_account.service_accounts["k8s-node"].id
    }
  )
  
  depends_on = [
    module.service_account
  ]
}