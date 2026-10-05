# Network

resource "yandex_vpc_network" "var_input" {
  for_each = local.net

  name        = each.value.name
  description = each.value.description
  labels      = each.value.labels
}

# Gateway

resource "yandex_vpc_gateway" "var_input" {
  for_each = local.gateway

  name   = each.value.name
  labels = each.value.labels

  shared_egress_gateway {}
}

# Route table

resource "yandex_vpc_route_table" "var_input" {
  for_each = local.route_table

  name = split(".", each.key)[1]

  network_id = yandex_vpc_network.var_input[
    each.value.network
  ].id

  labels = each.value.labels

  dynamic "static_route" {
    for_each = (
      each.value.static_route.gateway != null || each.value.static_route.next_hop_address != null
      ) ? [
      each.value.static_route
    ] : []

    content {
      destination_prefix = static_route.value.destination_prefix
      next_hop_address   = static_route.value.next_hop_address
      gateway_id = static_route.value.gateway != null ? (
        yandex_vpc_gateway.var_input[
          static_route.value.gateway
        ].id
      ) : null
    }
  }
}

# Subnet

resource "yandex_vpc_subnet" "var_input" {
  for_each = local.subnet

  name = split(".", each.key)[1]

  network_id = yandex_vpc_network.var_input[
    each.value.network
  ].id

  zone           = each.value.zone
  v4_cidr_blocks = [each.value.v4_cidr_blocks]

  labels      = each.value.labels
  description = each.value.description

  route_table_id = each.value.route_table != null ? (
    yandex_vpc_route_table.var_input[
      "${each.value.network}.${each.value.route_table}"
    ].id
  ) : null
}

# Security Group
resource "yandex_vpc_security_group" "var_input" {
  for_each = local.security_group

  name        = each.value.name
  description = each.value.description
  labels      = each.value.labels

  network_id = yandex_vpc_network.var_input[
    each.key
  ].id

  dynamic "ingress" {
    for_each = lookup(
      var.security_group_ingress,
      each.key,
      []
    )

    content {
      protocol       = ingress.value.protocol
      description    = ingress.value.description
      port           = lookup(ingress.value, "port", null)
      from_port      = lookup(ingress.value, "from_port", null)
      to_port        = lookup(ingress.value, "to_port", null)
      v4_cidr_blocks = ingress.value.v4_cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = lookup(
      var.security_group_egress,
      each.key,
      []
    )

    content {
      protocol       = egress.value.protocol
      description    = egress.value.description
      port           = lookup(egress.value, "port", null)
      from_port      = lookup(egress.value, "from_port", null)
      to_port        = lookup(egress.value, "to_port", null)
      v4_cidr_blocks = egress.value.v4_cidr_blocks
    }
  }
}