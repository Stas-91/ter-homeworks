resource "yandex_compute_instance" "vm-1" {
  name                      = "vm-1"
  allow_stopping_for_update = true

  scheduling_policy {
    preemptible = true        # Указание, что ВМ прерываемая
  }  

  resources {
        cores  = 2
        memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8ljvsrm3l1q2tgqji9"
      type     = "network-ssd"
      size     = "10"
    }
  }

  metadata = {
    ssh-keys = "stas:${file("~/.ssh/id_ed25519.pub")}"
  }

  network_interface {
    subnet_id  = "e9bab1n890lkhh5rnjg5"
    nat        = true
  }

}

output "internal_ip_address_vm-1" {
  value = "${yandex_compute_instance.vm-1.network_interface.0.nat_ip_address}"
}
