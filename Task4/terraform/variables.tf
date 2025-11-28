variable "project_name" {
  description = "Имя проекта, используется в именах ресурсов"
  type        = string
}


variable "yc_cloud_id" {
  description = "ID облака в Yandex Cloud"
  type        = string
}

variable "yc_folder_id" {
  description = "ID каталога (folder) в Yandex Cloud"
  type        = string
}

variable "yc_zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "public_subnet_cidr" {
  description = "CIDR публичной подсети"
  type        = string
  default     = "10.20.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR приватной подсети"
  type        = string
  default     = "10.20.2.0/24"
}

variable "allowed_ssh_cidrs" {
  description = "Список CIDR, которым можно ходить по SSH на bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_user" {
  description = "Пользователь для SSH (например, yc-user)"
  type        = string
  default     = "yc-user"
}

variable "ssh_public_key" {
  description = "Публичный SSH-ключ в формате 'ssh-rsa ...'"
  type        = string
}

variable "data_volume_size_gb" {
  description = "Размер отдельного диска для data-ноды"
  type        = number
  default     = 200
}
