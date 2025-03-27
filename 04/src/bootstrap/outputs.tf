output "sa_id" {
  description = "ID of the Terraform service account"
  value       = yandex_iam_service_account.terraform_test.id
}

output "access_key" {
  description = "Access key for S3 bucket"
  value       = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  sensitive   = true
}

output "secret_key" {
  description = "Secret key for S3 bucket"
  value       = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
  sensitive   = true
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = yandex_storage_bucket.tfstate_bucket.bucket
}

output "ydb_database_id" {
  description = "ID of the YDB database for locking"
  value       = yandex_ydb_database_serverless.tfstate_lock_db.id
}