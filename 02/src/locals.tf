### names for VM
locals {
  vm_names = {
    web = "${var.company_name}-${yandex_vpc_network.develop.name}-${var.vm_web_suffix}"
    db  = "${var.company_name}-${yandex_vpc_network.develop.name}-${var.vm_db_suffix}"
  }
}