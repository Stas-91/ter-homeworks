variable "cluster_id" {
  description = "ID of the existing MySQL cluster"
  type        = string
}

variable "database_name" {
  description = "Name of the database to create"
  type        = string
}

variable "username" {
  description = "Name of the MySQL user"
  type        = string
}

variable "password" {
  description = "Password for the MySQL user"
  type        = string
  sensitive   = true 
}

variable "user_roles" {
  description = "List of roles for the user in the database"
  type        = list(string)
  default     = ["ALL"]
}