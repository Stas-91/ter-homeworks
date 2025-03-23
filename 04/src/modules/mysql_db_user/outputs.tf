output "database_name" {
  description = "Name of the created database"
  value       = yandex_mdb_mysql_database.db.name
}

output "username" {
  description = "Name of the created user"
  value       = yandex_mdb_mysql_user.user.name
}