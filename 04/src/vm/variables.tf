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

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFY/ybgSeEva9G+UPavowLSz11sGvPdsYH1iTmO0JP71 stas_@DESKTOP-S3BGG7I"
  description = "ssh-keygen -t ed25519"
}

variable "yc_s3_credentials" {
  description = "Credentials for Yandex Cloud S3 (access_key and secret_key)"
  type = object({
    access_key = string
    secret_key = string
  })
  sensitive = true # Скрывает значения в выводе Terraform
}