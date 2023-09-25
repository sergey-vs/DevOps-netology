###cloud vars
variable "token" {
  type        = string
  default = ""
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  default = "b1g5e4ni06u5p88pf0hb"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default = "b1gpok0ichaplcklr1ve"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "env_name" {
  type = string
  default = "develop"
  description = "Enviroment name"
}

variable "vm_web_name" {
  type = string
  default = "web"
  description = "example vm_web_prefix"
}

variable "image_family" {
  type = string
  default = "ubuntu-2004-lts"
  description = "image for vms"
}

variable "platform_id" {
  type        = string
  default     = "standard-v1"
  description = "VM platform"
}


###vms
variable "ssh_user" {
  type = string
  default = "sergey"
  description = "user name for ssh"
}

variable "ssh_public_key" {
  type = string
  default = "~/.ssh/id_ed25519.pub"
  description = "password for ssh"
}

variable "packages" {
  type = list(any)
  description = "installing packages"
  default = [ "nginx", "mc" ]
}
/*###common vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "your_ssh_ed25519_key"
  description = "ssh-keygen -t ed25519"
}

###example vm_web var
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "example vm_web_ prefix"
}

###example vm_db var
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "example vm_db_ prefix"
}*/
