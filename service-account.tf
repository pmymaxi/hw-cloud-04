module "service_account" {
  source = "./modules/service-account"

  folder_id       = var.folder_id
  service_account = var.service_account
}