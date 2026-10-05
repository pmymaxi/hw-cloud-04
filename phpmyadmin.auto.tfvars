phpmyadmin = {
  name      = "phpmyadmin"
  namespace = "test"
  
  image = "phpmyadmin:latest"

  mysql = {
    host     = ""
    port     = 3306
    database = ""
    user     = ""
    password = ""
  }

  service = {
    type        = "LoadBalancer"
    port        = 80
    target_port = 80
  }

  replicas = 1
}