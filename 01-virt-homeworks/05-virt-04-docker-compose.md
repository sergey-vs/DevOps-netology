
# Домашнее задание к занятию 5.4. "Оркестрация группой Docker-контейнеров на примере Docker Compose"

***

## Задание 1

*Создайте собственный образ любой операционной системы  с помощью Packer (инструкция)*.

<details><summary><b>Сценарий выполнения задания 1 :</b></summary>

```bash
netology@deb11-vm1:~$ yc vpc network create --name network-vpc --labels my-label=netology --description "My network"
id: enpjkrklethegvnpi1v4
folder_id: b1gpok0ichaplcklr1ve
created_at: "2023-05-29T11:43:07Z"
name: network-vpc
description: My network
labels:
  my-label: netology

netology@deb11-vm1:~$ yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name network-vpc --description "My-subnet"
id: e9bro71h3nj18vnd2m7f
folder_id: b1gpok0ichaplcklr1ve
created_at: "2023-05-29T11:43:57Z"
name: my-subnet-a
description: My-subnet
network_id: enpjkrklethegvnpi1v4
zone_id: ru-central1-a
v4_cidr_blocks:
  - 10.1.2.0/24

netology@deb11-vm1:~$ cd yandex-cloud/

netology@deb11-vm1:~/yandex-cloud$ packer build centos-7-base.json 
yandex: output will be in this color.

==> yandex: Creating temporary RSA SSH key for instance...
==> yandex: Using as source image: fd8atq0nftbsilars2sa (name: "centos-7-v20230529", family: "centos-7")
==> yandex: Use provided subnet id e9bro71h3nj18vnd2m7f
==> yandex: Creating disk...
==> yandex: Creating instance...
==> yandex: Waiting for instance with id fhm54a90ornkh77lrvk2 to become active...
    yandex: Detected instance IP: 84.201.158.115
==> yandex: Using SSH communicator to connect: 84.201.158.115
==> yandex: Waiting for SSH to become available...
==> yandex: Connected to SSH!
==> yandex: Provisioning with shell script: /tmp/packer-shell2233913931
...
==> yandex: Stopping instance...
==> yandex: Deleting instance...
    yandex: Instance has been deleted!
==> yandex: Creating image: centos-7-base
==> yandex: Waiting for image to complete...
==> yandex: Success image create...
==> yandex: Destroying boot disk...
    yandex: Disk has been deleted!
Build 'yandex' finished after 2 minutes 10 seconds.

==> Wait completed after 2 minutes 10 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: centos-7-base (id: fd86t16m53btkbqndeb2) with family name centos

netology@deb11-vm1:~/yandex-cloud$ yc compute image list
+----------------------+---------------+--------+----------------------+--------+
|          ID          |     NAME      | FAMILY |     PRODUCT IDS      | STATUS |
+----------------------+---------------+--------+----------------------+--------+
| fd86t16m53btkbqndeb2 | centos-7-base | centos | f2eu9vp2082smvi43slh | READY  |
+----------------------+---------------+--------+----------------------+--------+

```

</details>

[centos-7-base.json](./src/504/packer)

*Чтобы получить зачёт, вам нужно предоставить скриншот страницы с созданным образом из личного кабинета YandexCloud*.

<div style="width:auto ; height:250px">

![Screenshot](./screenshots/yc_50401.png)

</div>

***

## Задание 2

2.1. *Создайте вашу первую виртуальную машину в YandexCloud с помощью web-интерфейса YandexCloud*.

<div style="width:auto ; height:250px">

![Screenshot](./screenshots/yc_50402.png)

</div>

2.2.* (**Необязательное задание**)

*Создайте вашу первую виртуальную машину в YandexCloud с помощью Terraform* (*вместо использования веб-интерфейса* YandexCloud).   
*Используйте Terraform-код в директории* ([src/terraform](./src/504/terraform)).

*Чтобы получить зачёт, вам нужно предоставить вывод команды terraform apply и страницы свойств, созданной ВМ из личного кабинета YandexCloud*

<div style="width:auto ; height:250px">

![Screenshot](./screenshots/yc_504022.png)

</div>

<details><summary><b>Сценарий выполнения задания 2.2 :</b></summary>

```bash

netology@deb11-vm1:~/terraform/virt_centos7$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.node01 will be created
  + resource "yandex_compute_instance" "node01" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + gpu_cluster_id            = (known after apply)
      + hostname                  = "node01.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0TmsFvjPzXlZI3r2qV7fTia5D2m0JTyTCZtnplJx2EMJCBKV4awQOiXwzeCZC/pRXuA4Mr/hR9FaR8fKYQH7okwJjXOCaUDawaEvRN5PefuyqulkNtsLFI0p+KrY3UJZTHmt+AyZXBRP0hfu+ucRhXYRvxAfGClDfc5xtOwAyTmO07dobCHvWy1WLGd2HjicGgZQkClZRdc83LMvN19VzPN6KF9Qg8fpqWalBuClmXKj81qblQVUXjt92531wrBiBC/mucCLpDb/qtFsvVOomtNr7ctBW6vGEFafIn9YNf3giTHD7V+cQLhH8FBBlRiNQVrBdPuZY2WYe3WSTIGoR780rSKLWBTH362yHSIZGDb2MfxgV/KKWrNff4SGsW4q2soXUVa53807sCG5PRqFUCgc8NbP0d8BURGb7vW+LQGElbnHy3u866KqyAnZ9Ru3JmoiNASjH+6Bkr+iofOTK555Lvxj5ru1JGHPNhiSh6KfJ3lDA2qPdwVwWb0Tq9JU= netology@deb11-vm1
            EOT
        }
      + name                      = "node01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8vc87hjitcfr2uuh5c"
              + name        = "root-node01"
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 8
          + memory        = 8
        }
    }

  # yandex_vpc_network.network-vpc will be created
  + resource "yandex_vpc_network" "network-vpc" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "nework-vpc"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet-vpc will be created
  + resource "yandex_vpc_subnet" "subnet-vpc" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet-vpc"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.1.2.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_node01_yandex_cloud = (known after apply)
  + internal_ip_address_node01_yandex_cloud = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

yandex_vpc_network.network-vpc: Creating...
yandex_vpc_network.network-vpc: Creation complete after 2s [id=enpn3phsn189os2knl0k]
yandex_vpc_subnet.subnet-vpc: Creating...
yandex_vpc_subnet.subnet-vpc: Creation complete after 1s [id=e9b2u61k1ksocqp3ae5k]
yandex_compute_instance.node01: Creating...
yandex_compute_instance.node01: Still creating... [10s elapsed]
yandex_compute_instance.node01: Still creating... [20s elapsed]
yandex_compute_instance.node01: Still creating... [30s elapsed]
yandex_compute_instance.node01: Creation complete after 33s [id=fhmmu6pbtos5jctia5l3]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node01_yandex_cloud = "84.201.157.187"
internal_ip_address_node01_yandex_cloud = "10.1.2.22"

netology@deb11-vm1:~/terraform/virt_centos7$ ssh centos@84.201.157.187

[centos@node01 ~]$ rpm -q centos-release
centos-release-7-9.2009.1.el7.centos.x86_64

```

</details>

***

## Задание 3

*С помощью Ansible и Docker Compose разверните на виртуальной машине из предыдущего задания систему мониторинга на основе Prometheus/Grafana. Используйте Ansible-код в директории ([src/ansible](./src/504/ansible))*.

*Чтобы получить зачёт, вам нужно предоставить вывод команды* `docker ps` , *все контейнеры, описанные в [docker-compose](./src/504/ansible/stack), должны быть в статусе* `Up`.

***

## Задание 4

1. *Откройте веб-браузер, зайдите на страницу* http://<внешний_ip_адрес_вашей_ВМ>:3000.
2. *Используйте для авторизации логин и пароль из .env-file*.
3. *Изучите доступный интерфейс, найдите в интерфейсе автоматически созданные docker-compose-панели с графиками(dashboards)*.
4. *Подождите 5-10 минут, чтобы система мониторинга успела накопить данные*.

*Чтобы получить зачёт, предоставьте*:

+ *скриншот работающего веб-интерфейса* **Grafana** *с текущими метриками*

***

## Задание 5(*)

*Создайте вторую ВМ и подключите её к мониторингу, развёрнутому на первом сервере*.

*Чтобы получить зачёт, предоставьте*:
 
+ *скриншот из Grafana, на котором будут отображаться метрики добавленного вами сервера*.
