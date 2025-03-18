resource "yandex_compute_instance" "web" {
  count = var.vm_count

  name = "${var.vm_name_prefix}-${count.index+1}"
  hostname = "${var.vm_name_prefix}-${count.index+1}"
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

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.vm_web_nat
    security_group_ids  = [yandex_vpc_security_group.example.id]
  }

 metadata = {
    ssh-keys = "${local.vm_md_ssh.user_name}:${local.vm_md_ssh.ssh_key}"
  }

  depends_on = [ yandex_compute_instance.db ]

}
