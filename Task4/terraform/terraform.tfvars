project_name   = "future20-data-yc"

yc_cloud_id    = "b1goou9b9auj4pf3220f"
yc_folder_id   = "b1gc0bitval37n7krcei"
yc_zone        = "ru-central1-a"

public_subnet_cidr  = "10.20.1.0/24"
private_subnet_cidr = "10.20.2.0/24"

allowed_ssh_cidrs = ["192.168.31.0/24", "217.118.85.0/24", "192.168.233.0/24"] 

ssh_user        = "haighrain"
ssh_public_key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIId5t2wf8lKTmZks6b1lUvqpBYgjYxgPm8uVajUi/i9E haighrain@ya.ru"

data_volume_size_gb = 300
