terraform {
  required_version = ">= 1.14.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.13" # или актуальную
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

# ─────────────────────────────────────────
# Сеть и подсети
# ─────────────────────────────────────────

resource "yandex_vpc_network" "main" {
  name = "${var.project_name}-network"
}

resource "yandex_vpc_subnet" "public" {
  name           = "${var.project_name}-public-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.public_subnet_cidr]
}

resource "yandex_vpc_subnet" "private" {
  name           = "${var.project_name}-private-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.private_subnet_cidr]
  route_table_id = yandex_vpc_route_table.private_rt.id
}
# ─────────────────────────────────────────
# NAT gateway + route table для приватной подсети
# ─────────────────────────────────────────

resource "yandex_vpc_gateway" "nat_gateway" {
  name = "${var.project_name}-nat-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "private_rt" {
  name       = "${var.project_name}-private-rt"
  network_id = yandex_vpc_network.main.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}


# ─────────────────────────────────────────
# Образ для ВМ
# ─────────────────────────────────────────

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

# ─────────────────────────────────────────
# Bastion VM (в публичной подсети)
# ─────────────────────────────────────────

resource "yandex_compute_instance" "bastion" {
  name        = "${var.project_name}-bastion"
  platform_id = "standard-v2"
  zone        = var.yc_zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}

# ─────────────────────────────────────────
# Data VM (в приватной подсети) + отдельный диск
# ─────────────────────────────────────────

resource "yandex_compute_disk" "data_disk" {
  name = "${var.project_name}-data-disk"
  type = "network-ssd"
  size = var.data_volume_size_gb
  zone = var.yc_zone
}

resource "yandex_compute_instance" "data" {
  name        = "${var.project_name}-data-node"
  platform_id = "standard-v2"
  zone        = var.yc_zone

  resources {
    cores         = 4
    memory        = 8
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  secondary_disk {
    disk_id = yandex_compute_disk.data_disk.id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }
}
