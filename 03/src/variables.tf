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

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

###vm vars

data "yandex_compute_image" "ubuntu" {
  family   = var.image_vm == null ? var.image_family : null
  image_id = var.image_vm 
}

variable "image_vm" {
  type        = string
  default     = null #"fd84f596tp5sv9tjvmc0"
  description = "VM image"
}

variable "image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "VM image family name"
}


# variable "vm_md_ssh" {
#   type = object({
#     user_name = string
#     ssh_key   = string
#   })
#   default = {
#     user_name = "stas"
#     ssh_key   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFY/ybgSeEva9G+UPavowLSz11sGvPdsYH1iTmO0JP71 stas_@DESKTOP-S3BGG7I"
#   }  
#   description = "VM metadata - user name and ssh key"
# }

###vm vars web

variable "vm_count" {
  type        = number
  default     = 2
  description = "Number of virtual machines to deploy"
}

variable "vm_name_prefix" {
  type    = string
  default = "web"
  description = "VM name prefix"
}

variable "vm_web_resources" {
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
    disk_volume   = number
    disk_type     = string
  })
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 50
    disk_volume   = 10
    disk_type     = "network-ssd"
  }
  description = "VM web instance resources"
}

variable "vm_web_preemptible" {
  type        = bool
  default     = true
  description = "VM web scheduling policy (preemptible)"
}

variable "vm_web_nat" {
  type        = bool
  default     = true
  description = "VM web external IP policy (nat)"
}

###vm vars db

variable "each_vm" {
  type = list(object({
    vm_name     = string,
    cpu         = number,
    ram         = number,
    disk_volume = number,
    disk_type   = string,
    preemptible = bool,
    nat         = bool
  }))
description = "List of VM configurations"
}


###vm disks vars

variable "vm_name_prefix_disks" {
  type    = string
  default = "storage"
  description = "VM name prefix"
}

variable "vm_count_disk" {
  type        = number
  default     = 3
  description = "Number of VM disks to deploy"
}

variable "vm_disk" {
  type = object({
    name = string
    type = string
    zone = string
    size = number
  })
  default = {
    name = "disk"
    type = "network-ssd"
    zone = "ru-central1-a"
    size = 1
  }
  description = "VM disk"
}

variable "vm_storage_nat" {
  type        = bool
  default     = false
  description = "VM web external IP policy (nat)"
}
