output "out" {

    value=concat(module.marketing_vm.fqdn , module.analytics_vm.fqdn)
}

output "bucket_name" {
  description = "The name of the bucket."
  value       = module.s3.bucket_name
}

output "secret_path" {
  value       = "${vault_kv_secret_v2.example.mount}/${vault_kv_secret_v2.example.name}"
  description = "Full path to the secret"
}

output "secret_mount" {
  value       = vault_kv_secret_v2.example.mount
  description = "Mount point of the secret"
}

output "secret_name" {
  value       = vault_kv_secret_v2.example.name
  description = "Name of the secret"
}

output "secret_data" {
  value       = nonsensitive(jsondecode(vault_kv_secret_v2.example.data_json))
  description = "Secret data as a map"
  sensitive   = false  # Помечаем как чувствительные данные
}