###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

# VPC Configurations
variable "vpc_configs" {
  default = {
    dev = {
      network_name = "develop"
      subnets = [
        { zone = "ru-central1-a", cidr = "10.0.1.0/24" }
      ]
    }
    prod = {
      network_name = "production"
      subnets = [
        { zone = "ru-central1-a", cidr = "10.1.1.0/24" },
        { zone = "ru-central1-b", cidr = "10.1.2.0/24" },
        { zone = "ru-central1-d", cidr = "10.1.3.0/24" }
      ]
    }
  }
}

# VM Common Configurations
variable "vm_common" {
  default = {
    username      = "ubuntu"
    packages      = ["vim", "nginx"]
    runcmd        = "runcmd:\n  - [ systemctl, enable, nginx ]\n  - [ systemctl, start, nginx ]"
    image_family  = "ubuntu-2004-lts"
    serial_port_enable = 1
  }
}

variable "vms_ssh_root_key" {
  type = string
}

# VM Specific Configurations
variable "vm_instances" {
  default = {
    marketing = {
      env_name       = "develop"
      instance_name  = "webs"
      instance_count = 1
      public_ip      = true
      subnet_zones   = ["ru-central1-a"]
      labels = {
        owner   = "s.pomelnikov"
        project = "marketing"
      }
    }
    analytics = {
      env_name       = "stage"
      instance_name  = "web-stage"
      instance_count = 1
      public_ip      = true
      subnet_zones   = ["ru-central1-a"]
      labels = {
        owner   = "s.pomelnikov"
        project = "analytics"
      }
    }
  }
}

# MySQL Configuration
variable "mysql_config" {
  default = {
    cluster_name   = "example"
    ha             = true
    database_name  = "test"
    username       = "app"
    password       = "Qwerty123"
    user_roles     = ["ALL"]
  }
}

# S3 Configuration
variable "s3_config" {
  default = {
    bucket_prefix = "simple-bucket"
    max_size      = 1073741824
    versioning    = {
      enabled = true
    }
  }
}

# Random String Configuration
variable "random_string_config" {
  default = {
    length  = 8
    upper   = false
    lower   = true
    numeric = true
    special = false
  }
}

# # Vault Configuration
# variable "vault_config" {
#   default = {
#     mount = "secret"
#     name  = "example"
#     data  = {
#       test = "congrats!"
#     }
#   }
# }

# variable "yc_s3_credentials" {
#   description = "Credentials for Yandex Cloud S3 (access_key and secret_key)"
#   type = object({
#     access_key = string
#     secret_key = string
#   })
#   sensitive = true # Скрывает значения в выводе Terraform
# }