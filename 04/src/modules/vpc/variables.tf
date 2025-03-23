variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "my-network"
}

variable "subnets" {
  description = "List of subnets with their zones and CIDR blocks"
  type = list(object({
    zone = string
    cidr = string
  }))
  default = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}