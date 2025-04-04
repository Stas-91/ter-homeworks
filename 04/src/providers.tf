terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "> 5.1"
    }

    random = {
      source  = "hashicorp/random"
      version = "> 3.5"
    }
  }
  required_version = "~>1.8.4"
}

provider "yandex" {
  token                    = var.token
  cloud_id                 = "b1g8ta6qu7na0ir2khnv"
  folder_id                = "b1g8kve3609ag8bp327e"
  # service_account_key_file = file("~/.authorized_key.json")
  zone                     = "ru-central1-a" #(Optional) 
}

provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = "education"
}