output "network" {
  description = "Созданные VPC сети и их подсети"

  value = {
    for network_key, network in yandex_vpc_network.var_input :
    network_key => {
      network_id = network.id

      subnet = {
        for subnet_key, subnet in yandex_vpc_subnet.var_input :
        split(".", subnet_key)[1] => {
          subnet_id      = subnet.id
          zone           = subnet.zone
          v4_cidr_blocks = subnet.v4_cidr_blocks
        }
        if subnet.network_id == network.id
      }
    }
  }
}

output "security_group" {
  description = "Созданные группы безопасности"

  value = {
    for key, sg in yandex_vpc_security_group.var_input :
    key => {
      sg_id            = sg.id
      sg_name          = sg.name
      apply_network_id = sg.network_id
    }
  }
}

output "gateway" {
  description = "Созданные шлюзы"

  value = {
    for key, gateway in yandex_vpc_gateway.var_input :
    key => {
      gateway_id = gateway.id
    }
  }
}

output "route_table" {
  description = "Созданные таблицы маршрутизации и статические маршруты"

  value = {
    for key, route_table in yandex_vpc_route_table.var_input :
    key => {
      route_table_id = route_table.id
      network_id     = route_table.network_id

      static_route = [
        for route in route_table.static_route : {
          destination_prefix = route.destination_prefix
          next_hop_address   = route.next_hop_address
          gateway_id         = route.gateway_id
        }
      ]
    }
  }
}