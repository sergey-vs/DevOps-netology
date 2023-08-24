variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "name of a VM (only lower case latters)"
}
variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "the type of virtual machine to create"
}


 variable "vm_db_cores" { 
  type        = number
  default     = "2"
  description = "number of CPU cores"
}

variable "vm_db_ram" { 
  type        = number
  default     = "2"
  description = "amount of RAM"
}

variable "vm_db_core_fraction" {
  description = "% of CPU"
  type        = number
  default     = "20"
}
