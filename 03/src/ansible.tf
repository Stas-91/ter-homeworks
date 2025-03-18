locals {
  to_instance_list = {
    "webservers" = yandex_compute_instance.web
    "databases" = yandex_compute_instance.db
    "storage" = yandex_compute_instance.storage
  }
}

locals {
  groups = {
    for group_name, resource in local.to_instance_list : group_name => try(
      [
        for instance in resource : {
          name = instance.name
          network_interface = instance.network_interface
          fqdn = instance.fqdn
        }
      ],
      [{
        name = resource.name
        network_interface = resource.network_interface
        fqdn = resource.fqdn
      }]
    )
  }
  inventory = templatefile("${path.module}/hosts.tftpl", {
    groups = local.groups
  })
}

resource "local_file" "inventory" {
  content = local.inventory
  filename = "${path.module}/inventory.ini"
}

variable "web_provision" {
  type        = bool
  default     = true
  description = "ansible provision switch variable"
}

# Генерация случайных паролей для хостов
resource "random_password" "each" {
  for_each = toset([for instance in yandex_compute_instance.web : instance.name])
  length   = 16
  special  = true

  depends_on = [
    yandex_compute_instance.web,
  ]
}

# Создание файла secrets.json
resource "local_file" "secrets" {
  content  = jsonencode({
    "secrets" = { for k, v in random_password.each : k => v.result }
  })
  filename = "${path.module}/secrets.json"

  depends_on = [
    random_password.each
  ]

}

resource "null_resource" "web_hosts_provision" {
  count = var.web_provision == true ? 1 : 0
  #Ждем создания инстанса и инвентори
  depends_on = [
    yandex_compute_instance.storage,
    yandex_compute_instance.web,
    yandex_compute_instance.db,
    local_file.inventory,
    local_file.secrets
  ]

  #Запуск ansible-playbook
  provisioner "local-exec" {
    # without secrets
    # command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/inventory.ini ${abspath(path.module)}/test.yml"

    # with secrets
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ${abspath(path.module)}/inventory.ini ${abspath(path.module)}/test.yml --extra-vars '@${abspath(path.module)}/secrets.json'"
  }
  triggers = {
    always_run      = "${timestamp()}" #всегда т.к. дата и время постоянно изменяются

  }

}
