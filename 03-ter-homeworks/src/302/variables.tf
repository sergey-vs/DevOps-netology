###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
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
  description = "VPC network & subnet name"
}

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = ""
}


variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "name of a VM (only lower case latters)"
}

variable "vm_web_cores" { 
  type        = number
  default     = "2"
  description = "number of CPU cores"
}

variable "vm_web_ram" { 
  type        = number
  default     = "1"
  description = "amount of RAM"
}

variable "vm_web_core_fraction" {
  description = "% of CPU"
  type        = number
  default     = "5"
}


variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "the type of virtual machine to create"
}

variable "vm_web_resources" {
  type = map
  default = {
  cores = "2" 
  memory = "1"
  core_fraction = "5"
  }
}

variable "vm_db_resources" {
  type = map
  default = {
  cores = "2"
  memory = "2"
  core_fraction = "20"
  }
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjc26jCbJv5dGtWqtnetEWWavh+6nuoAm1KyXMx+iRm6oJ8gM28XbRgH5bKo0nQZ3tTMwDHeXwPXwFr1gHvoEvRFOijyfC2WHk0YoYRyD9rrgHHPpPguJ543e4DNHyCCwCcvVSR2VoFNbfCQQFLzDQEv19t7phkCE4SkzPta/mwNg6sRnPZnONJW9+uH1lO0037xub2MX7zvcVoQVMH5BH3TWTv1dQnOruGMN2gybECKESOH27vYJxZ+7YDqU69IKOX1gqYR9n4dZ+D2RQdTQ+sHPIqir8bbx2w6Es242TRrgyWpuzxE8QGtM7jz4Uok8dLJ3aNX19gFX1Xwk1z+2Qan8/UKVjGOinhUNZLdw5MLSD7XjkkciCcKE0MKdPrFFnPM5rISIbNTkOUAbSVQX7KpE9Q1ryyijUhFOssv6yLp8Gg2jVt7nRCu7xhSyBn5pJbipgt9SNe5avR9nczJUz838LPhEb9YFMgZzd38oDNGmYCcCv2d+c62kwsObXRWc= sergey@kali"
  description = "ssh-keygen -t ed25519"
}
