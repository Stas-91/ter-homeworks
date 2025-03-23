resource "yandex_mdb_mysql_cluster" "cluster" {
  name        = var.cluster_name
  network_id  = var.network_id
  environment = var.environment
  version     = var.mysql_version

  resources {
    resource_preset_id = var.resource_preset_id
    disk_type_id       = var.disk_type_id
    disk_size          = var.disk_size
  }

  dynamic "host" {
    for_each = var.ha ? [
      { zone = "ru-central1-a" },
      { zone = "ru-central1-b" }
    ] : [
      { zone = "ru-central1-a" }
    ]

    content {
      zone = host.value.zone
    }
  }
}