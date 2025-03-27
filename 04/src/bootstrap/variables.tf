variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  default = "b1g8ta6qu7na0ir2khnv"
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  default = "b1g8kve3609ag8bp327e"
}

variable "yc_zone" {
  description = "Default zone for resources"
  type        = string
  default     = "ru-central1-a"
}

# variable "service_account_key_file" {
#   description = "Path to the service account key file for initial authentication"
#   type        = string
# }

variable "tfstate_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "tfstate-bucket"
}

variable "token" {
  type = string
}