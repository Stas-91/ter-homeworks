terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.35"
    }
  }
  required_version = "~> 1.8.4"
}

provider "yandex" {
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
  # для начальной настройки
  token     = var.token
}

# Сервисный аккаунт для Terraform
resource "yandex_iam_service_account" "terraform_test" {
  name        = "terraform-test"
  description = "Service account for Terraform operations"
  folder_id   = var.yc_folder_id
}

# Назначение роли storage.admin для работы с S3
resource "yandex_resourcemanager_folder_iam_member" "storage_admin" {
  folder_id = var.yc_folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.terraform_test.id}"
}

# Назначение роли editor для управления ресурсами в папке
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.terraform_test.id}"
}

# Создание статического ключа доступа для сервисного аккаунта
resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = yandex_iam_service_account.terraform_test.id
  description        = "Static key for Terraform S3 backend"
}

# S3-бакет для хранения terraform.tfstate
resource "yandex_storage_bucket" "tfstate_bucket" {
  bucket     = var.tfstate_bucket_name
  access_key = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa_static_key.secret_key

  versioning {
    enabled = true # Включаем версионирование для защиты состояния
  }

  lifecycle_rule {
    id      = "expire-old-versions"
    enabled = true
    filter {  
      prefix = ""
    }
    noncurrent_version_expiration {
      days = 90 # Удаляем старые версии через 90 дней
    }
  }
  depends_on = [
    yandex_resourcemanager_folder_iam_member.storage_admin,
    yandex_resourcemanager_folder_iam_member.editor
  ]
}

# YDB база данных для блокировок состояния
resource "yandex_ydb_database_serverless" "tfstate_lock_db" {
  name        = "tfstate-lock-db"
  folder_id   = var.yc_folder_id
  description = "YDB for Terraform state locking"

  serverless_database {
    storage_size_limit = 1 # Лимит в ГБ
  }
}