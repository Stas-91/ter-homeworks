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

module "vpc_dev" {
  source       = "../modules/vpc"
  network_name = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}

module "vpc_prod" {
  source       = "../modules/vpc"
  network_name = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.1.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.1.2.0/24" },
    { zone = "ru-central1-d", cidr = "10.1.3.0/24" },
  ]
}

output "vpc_dev_network_id" {
  value = module.vpc_dev.network_id
}

output "vpc_dev_subnet_ids" {
  value = module.vpc_dev.subnet_ids
}

output "vpc_prod_network_id" {
  value = module.vpc_prod.network_id
}

output "vpc_prod_subnet_ids" {
  value = module.vpc_prod.subnet_ids
}