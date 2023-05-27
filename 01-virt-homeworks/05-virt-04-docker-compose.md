# Домашнее задание к занятию 5.4. "Оркестрация группой Docker-контейнеров на примере Docker Compose"

***

## Задание 1

*Создайте собственный образ любой операционной системы  с помощью Packer (инструкция)*.

<details><summary><b>Сценарий выполнения задания 1 :</b></summary>


```shell
netology@deb11-vm1:~$ yc vpc network create --name network-vpc --labels my-label=netology --description "My network"
id: enpmmf5psu3cpo130b6m
folder_id: b1gpok0ichaplcklr1ve
created_at: "2023-05-25T15:51:22Z"
name: network-vpc
description: My network
labels:
  my-label: netology

netology@deb11-vm1:~$ yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-net network-vpc --description "My-subnet"
ERROR: unknown flag: --network-net
netology@deb11-vm1:~$ yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name network-vpc --description "My-subnet"
id: e9b40kdedhfbrfndr94e
folder_id: b1gpok0ichaplcklr1ve
created_at: "2023-05-25T15:56:48Z"
name: my-subnet-a
description: My-subnet
network_id: enpmmf5psu3cpo130b6m
zone_id: ru-central1-a
v4_cidr_blocks:
  - 10.1.2.0/24

netology@deb11-vm1:~/yandex-cloud$ packer validate debian11.json
The configuration is valid.
netology@deb11-vm1:~/yandex-cloud$ sudo packer build debian11.json
yandex: output will be in this color.

==> yandex: Creating temporary RSA SSH key for instance...
==> yandex: Using as source image: fd89dg1rq7uqslc6eigm (name: "debian-11-v20230522", family: "debian-11")
==> yandex: Use provided subnet id e9b40kdedhfbrfndr94e
==> yandex: Creating disk...
==> yandex: Creating instance...
==> yandex: Waiting for instance with id fhmrntddebdhpsjqaeqe to become active...
    yandex: Detected instance IP: 158.160.102.137
==> yandex: Using SSH communicator to connect: 158.160.102.137
==> yandex: Waiting for SSH to become available...
==> yandex: Connected to SSH!
==> yandex: Provisioning with shell script: /tmp/packer-shell2379814482

...
==> yandex: Stopping instance...
==> yandex: Deleting instance...
    yandex: Instance has been deleted!
==> yandex: Creating image: debian-11-nginx-2023-05-27t10-29-37z
==> yandex: Waiting for image to complete...
==> yandex: Success image create...
==> yandex: Destroying boot disk...
    yandex: Disk has been deleted!
Build 'yandex' finished after 3 minutes 31 seconds.

==> Wait completed after 3 minutes 31 seconds

==> Builds finished. The artifacts of successful builds are:
--> yandex: A disk image was created: debian-11-nginx-2023-05-27t10-29-37z (id: fd8ies1oodo9sue03vih) with family name debian-web-server
netology@deb11-vm1:~/yandex-cloud$ yc compute image list
+----------------------+--------------------------------------+-------------------+----------------------+--------+
|          ID          |                 NAME                 |      FAMILY       |     PRODUCT IDS      | STATUS |
+----------------------+--------------------------------------+-------------------+----------------------+--------+
| fd8ies1oodo9sue03vih | debian-11-nginx-2023-05-27t10-29-37z | debian-web-server | f2eu5sakphet32oa2ss7 | READY  |
+----------------------+--------------------------------------+-------------------+----------------------+--------+

```
</details>

[debian11.json](./src/504/packer)

*Чтобы получить зачёт, вам нужно предоставить скриншот страницы с созданным образом из личного кабинета YandexCloud*.
<div style="width:auto ; height:250px">

![Screenshot](./screenshots/yc_50401.png)

</div>
***

## Задание 2

2.1. *Создайте вашу первую виртуальную машину в YandexCloud с помощью web-интерфейса YandexCloud*.

2.2.* (**Необязательное задание**)

*Создайте вашу первую виртуальную машину в YandexCloud с помощью Terraform* (*вместо использования веб-интерфейса* YandexCloud).   
*Используйте Terraform-код в директории* (src/terraform).

*Чтобы получить зачёт, вам нужно предоставить вывод команды terraform apply и страницы свойств, созданной ВМ из личного кабинета YandexCloud*

***

## Задание 3

*С помощью Ansible и Docker Compose разверните на виртуальной машине из предыдущего задания систему мониторинга на основе Prometheus/Grafana. Используйте Ansible-код в директории (src/ansible)*.

*Чтобы получить зачёт, вам нужно предоставить вывод команды* `docker ps` , *все контейнеры, описанные в docker-compose, должны быть в статусе* `Up`.

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
