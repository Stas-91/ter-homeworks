terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}

variable "single_ip" {
  type        = string
  description = "ip-адрес"
  default     = "192.168.0.1" 

  validation {
    condition     = can(cidrhost("${var.single_ip}/32", 0))
    error_message = "Значение должно быть корректным IP-адресом (например, 192.168.0.1)"
  }
}

variable "ip_list" {
  type        = list(string)
  description = "список ip-адресов"
  default     = ["192.168.0.1", "1.1.1.1", "127.0.0.1"] 

  validation {
    condition     = alltrue([for ip in var.ip_list : can(cidrhost("${ip}/32", 0))])
    error_message = "Все значения в списке должны быть корректными IP-адресами"
  }
}

resource "null_resource" "example" {
  triggers = {
    single_ip = var.single_ip
    ip_list   = join(",", var.ip_list)
  }
}