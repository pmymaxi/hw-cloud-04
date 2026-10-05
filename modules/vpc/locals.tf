locals {
  net = var.vpc_network

  subnet = merge([
    for network_name, network in var.vpc_subnet : {
      for subnet_name, subnet in network :
      "${network_name}.${subnet_name}" => merge(subnet, {
        network = network_name
      })
    }
  ]...)

  gateway = var.gateway

  route_table = merge([
    for network_name, route_tables in var.route_table : {
      for table_name, table in route_tables :
      "${network_name}.${table_name}" => merge(table, {
        network = network_name
      })
    }
  ]...)

  security_group = var.security_group

}