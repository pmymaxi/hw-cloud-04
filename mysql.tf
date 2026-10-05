module "mysql" {
  source = "./modules/mysql"

  mysql = var.mysql
}