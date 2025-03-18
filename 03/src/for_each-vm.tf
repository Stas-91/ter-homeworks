resource "yandex_compute_instance" "db" {
  for_each = { for vm in var.each_vm : vm.vm_name => vm }

  name = each.value.vm_name
  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  scheduling_policy { preemptible = each.value.preemptible }  

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = each.value.disk_type
      size     = each.value.disk_volume
    }
  }

 metadata = {
    ssh-keys = "${local.vm_md_ssh.user_name}:${local.vm_md_ssh.ssh_key}"
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = each.value.nat
    security_group_ids  = [yandex_vpc_security_group.example.id]
  }

}