###cloud vars

variable "cloud_id" {
  type        = string
  default     = "b1g8ta6qu7na0ir2khnv"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1g8kve3609ag8bp327e"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "zone" {
  type = object({
    zone-a = string
    zone-b = string
  })
  default = {
    zone-a = "ru-central1-a"
    zone-b = "ru-central1-b"
  }
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "cidr" {
  type = object({
    cidr0 = list(string)
    cidr1 = list(string)
  })
  default     = {
    cidr0 = ["10.0.1.0/24"]
    cidr1 = ["10.0.2.0/24"]
  }
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type = object({
    net      = string
    platform = string
    db       = string
  })
  default = {
    net = "develop"
    platform = "develop-a"
    db = "develop-b"
  }
  description = "VPC network & subnet name"
}

variable "image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "VM image family name"
}

variable "platform_id" {
  type        = string
  default     = "standard-v3"
  description = "VM platform id"
}

###ssh vars

# variable "vms_ssh_root_key" {
#   type        = string
#   default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFY/ybgSeEva9G+UPavowLSz11sGvPdsYH1iTmO0JP71 stas_@DESKTOP-S3BGG7I"
#   description = "ssh-keygen -t ed25519"
# }

variable "vmmd_ssh" {
  type = object({
    user_name = string
    ssh_key = string
  })
  default = {
    user_name = "ubuntu"
    ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFY/ybgSeEva9G+UPavowLSz11sGvPdsYH1iTmO0JP71 stas_@DESKTOP-S3BGG7I"
  }  
  description = "VM metadata - user name and ssh key"
}


### test var

variable "test" {
  type = tuple([
    object({
      dev1 = list(string)
    }),
    object({
      dev2 = list(string)
    }),
    object({
      prod1 = list(string)
    })
  ])
  default = [{
    dev1 = [ "test ssh", "test ip" ]
    }, {
    dev2 = [ "test ssh", "test ip" ]
    }, {
    prod1 = [ "test ssh", "test ip" ]
    }]
  description = "values for test"
}
