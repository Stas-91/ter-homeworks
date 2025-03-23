variable "cluster_name" {
  description = "Name of the MySQL cluster"
  type        = string
}

variable "network_id" {
  description = "ID of the network where the cluster will be deployed"
  type        = string
}

variable "ha" {
  description = "Enable high availability (2 hosts) if true, single host if false"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment type: PRESTABLE or PRODUCTION"
  type        = string
  default     = "PRODUCTION"
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0"
}

variable "resource_preset_id" {
  description = "Resource preset (e.g., s2.micro)"
  type        = string
  default     = "s2.micro"
}

variable "disk_type_id" {
  description = "Disk type (e.g., network-ssd)"
  type        = string
  default     = "network-ssd"
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 20
}