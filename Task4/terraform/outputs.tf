output "network_id" {
  description = "ID VPC сети"
  value       = yandex_vpc_network.main.id
}

output "public_subnet_id" {
  description = "ID публичной подсети"
  value       = yandex_vpc_subnet.public.id
}

output "private_subnet_id" {
  description = "ID приватной подсети"
  value       = yandex_vpc_subnet.private.id
}

output "bastion_external_ip" {
  description = "Внешний IP bastion-хоста"
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}

output "data_instance_id" {
  description = "ID data-ноды"
  value       = yandex_compute_instance.data.id
}

output "data_disk_id" {
  description = "ID отдельного диска для данных"
  value       = yandex_compute_disk.data_disk.id
}
