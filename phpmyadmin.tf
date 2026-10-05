module "phpmyadmin" {
  source = "./modules/phpmyadmin"

  phpmyadmin = merge(
    var.phpmyadmin,
    {
      mysql = {
        host     = module.mysql.fqdn[0]
        port     = 3306
        database = module.mysql.database_name
        user     = module.mysql.user_name
        password = var.mysql.user.password
      }
    }
  )

  depends_on = [
    module.kubernetes,
    module.mysql
  ]
}