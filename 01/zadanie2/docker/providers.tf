terraform {
    required_providers {
        yandex = {
            source = "yandex-cloud/yandex"
            version = ">=0.72.0"
        }
        docker = {
        source  = "kreuzwerker/docker"
        version = "~> 3.0.1"
        }        
    }
    required_version = ">= 1.8.4"
}

variable "yandex_cloud_token" {
  type        = string
  description = "yandex_cloud_token"
}

variable "docker_remote_host" {
  type        = string
  description = "yandex_cloud_token"
}


provider "yandex" {
  token     = var.yandex_cloud_token
  cloud_id  = "b1g8ta6qu7na0ir2khnv"
  folder_id = "b1g8kve3609ag8bp327e"
  zone      = "ru-central1-a"
}

provider "docker" {
  host     = "ssh://stas@${var.docker_remote_host}:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}