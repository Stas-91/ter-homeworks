resource "yandex_compute_disk" "empty-disk" {
  count = var.vm_count_disk

  name       = "${var.vm_disk.name}-${count.index+1}"
  type       = var.vm_disk.type
  zone       = var.default_zone
  size       = var.vm_disk.size
}

resource "yandex_compute_instance" "storage" {
    name = "${var.vm_name_prefix_disks}"
  resources {
    cores = var.vm_web_resources.cores
    memory = var.vm_web_resources.memory
  }

  scheduling_policy { preemptible = var.vm_web_preemptible }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = var.vm_web_resources.disk_type
      size = var.vm_web_resources.disk_volume
    }
  }

  dynamic "secondary_disk" {
    for_each = toset(yandex_compute_disk.empty-disk[*].id)
    content {
      disk_id = secondary_disk.value
    }
  }  

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.vm_storage_nat
    security_group_ids  = [yandex_vpc_security_group.example.id]
  }

 metadata = {
    ssh-keys = "${local.vm_md_ssh.user_name}:${local.vm_md_ssh.ssh_key}"
  }
}
