output "cluster_id" {
  description = "ID of the created MySQL cluster"
  value       = yandex_mdb_mysql_cluster.cluster.id
}

output "host_names" {
  description = "List of host FQDNs"
  value       = yandex_mdb_mysql_cluster.cluster.host[*].fqdn
}