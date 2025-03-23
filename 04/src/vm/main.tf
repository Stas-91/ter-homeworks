terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = "~>1.8.4"
}

provider "yandex" {
  #token                    = var.yc_token
  cloud_id                 = "b1g8ta6qu7na0ir2khnv"
  folder_id                = "b1g8kve3609ag8bp327e"
  service_account_key_file = file("~/.authorized_key.json")
  zone                     = "ru-central1-a" #(Optional) 
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket   = "simple-bucket-iqz461d3" # Замените на ваше имя бакета
    key      = "vpc/terraform.tfstate"
    region   = "ru-central1"
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    access_key = var.yc_s3_credentials.access_key
    secret_key = var.yc_s3_credentials.secret_key
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true # Отключаем запрос AWS account ID
  }
}

data "template_file" "cloudinit" {
  template = file("../cloud-init.tpl")
  vars = {
    username  = "ubuntu"
    ssh_key1  = var.vms_ssh_root_key
    packages  = jsonencode(["vim", "nginx"])
    runcmd    = "runcmd:\n  - [ systemctl, enable, nginx ]\n  - [ systemctl, start, nginx ]"
  }
}

module "marketing_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop"
  network_id     = data.terraform_remote_state.vpc.outputs.vpc_dev_network_id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [data.terraform_remote_state.vpc.outputs.vpc_dev_subnet_ids["ru-central1-a"]]
  instance_name  = "webs"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true
  labels = {
    owner   = "s.pomelnikov"
    project = "marketing"
  }
  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}

module "analytics_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "stage"
  network_id     = data.terraform_remote_state.vpc.outputs.vpc_dev_network_id
  subnet_zones   = ["ru-central1-a"]
  subnet_ids     = [data.terraform_remote_state.vpc.outputs.vpc_dev_subnet_ids["ru-central1-a"]]
  instance_name  = "web-stage"
  instance_count = 1
  image_family   = "ubuntu-2004-lts"
  public_ip      = true
  labels = {
    owner   = "s.pomelnikov"
    project = "analytics"
  }
  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = 1
  }
}