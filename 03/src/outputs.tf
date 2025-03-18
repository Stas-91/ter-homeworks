# output "vm_web" {
#   value = [
#     yandex_compute_instance.web[*].name,
#     yandex_compute_instance.web[*].network_interface.0.ip_address,
#     yandex_compute_instance.web[*].network_interface.0.nat_ip_address,
#     yandex_compute_instance.web[*].fqdn
#   ]
# }

# output "vm_db" {
#   value = [
#     values(yandex_compute_instance.db)[*].name,
#     values(yandex_compute_instance.db)[*].network_interface.0.ip_address,
#     values(yandex_compute_instance.db)[*].network_interface.0.nat_ip_address,
#     values(yandex_compute_instance.db)[*].fqdn
#   ]
# }

# output "web" {
#     value = [
#         for i in range(var.vm_count) : {
#             "name" = yandex_compute_instance.web[i].name,
#             "id" = yandex_compute_instance.web[i].id,
#             "fqdn" = yandex_compute_instance.web[i].fqdn
#         }
#     ]
# }


output "vm_all" {
  value = concat(
    [for vm in yandex_compute_instance.web : {
      "name" = vm.name,
      "id" = vm.id,
      "fqdn" = vm.fqdn
    }],
   [for vm in yandex_compute_instance.db : {
      "name" = vm.name,
      "id" = vm.id,
      "fqdn" = vm.fqdn
    }]
  )
}
