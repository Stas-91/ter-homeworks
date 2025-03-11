resource "yandex_vpc_network" "develop" {
  name = var.vpc_name.net
}
resource "yandex_vpc_subnet" "develop-a" {
  name           = var.vpc_name.platform
  zone           = var.zone.zone-a
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.cidr.cidr0
  route_table_id = yandex_vpc_route_table.rt.id  
}

resource "yandex_vpc_subnet" "develop-b" {
  name           = var.vpc_name.db
  zone           = var.zone.zone-b
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.cidr.cidr1
  route_table_id = yandex_vpc_route_table.rt.id  
}

resource "yandex_vpc_gateway" "nat_gateway" {
  folder_id      = var.folder_id
  name = "test-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
  folder_id      = var.folder_id
  name       = "test-route-table"
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

resource "yandex_compute_instance" "platform" {
  name        = local.vm_names.web
  platform_id = var.platform_id
  resources {
    cores         = var.vm_web_resources.cores
    memory        = var.vm_web_resources.memory
    core_fraction = var.vm_web_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop-a.id
    nat       = var.vm_web_nat
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${var.vmmd_ssh.user_name}:${var.vmmd_ssh.ssh_key}"
  }
}

resource "yandex_compute_instance" "db" {
  name        = local.vm_names.db
  platform_id = var.platform_id
  zone = var.zone.zone-b  
  resources {
    cores         = var.vm_db_resources.cores
    memory        = var.vm_db_resources.memory
    core_fraction = var.vm_db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop-b.id
    nat       = var.vm_db_nat
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "${var.vmmd_ssh.user_name}:${var.vmmd_ssh.ssh_key}"
  }
}