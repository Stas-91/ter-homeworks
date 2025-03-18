locals{
  vm_md_ssh = {
    user_name = "ubuntu"
    ssh_key = file("~/.ssh/id_ed25519.pub")
  }
}
