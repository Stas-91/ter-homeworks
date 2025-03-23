resource "yandex_vpc_network" "network" {
  name = var.network_name
}

resource "yandex_vpc_subnet" "subnet" {
  for_each = { for subnet in var.subnets : subnet.zone => subnet }

  name           = "${var.network_name}-${each.key}"
  zone           = each.value.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = [each.value.cidr]
}