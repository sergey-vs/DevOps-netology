# Домашнее задание к занятию 5.2. «Применение принципов IaaC в работе с виртуальными машинами»

## Задание 1
> *Опишите основные преимущества применения на практике IaaC-паттернов.*

Использование IaaC позволяет максимально упростить и автоматизировать процессы управления ИТ-инфраструктурой, увеличить ее надежность
+ Непрерывная интеграция (CI) - сокращение стоимости исправления дефекта за счет его раннего выявления.
+ Непрерывная доставка (CD) - изменения выпускаются небольшими партиями, их можно быстро изменить или устранить.
+ Непрерывное развёртывание (CD) - упраздняет ручные действия, не требуя непосредственного утверждения со стороны ответственного лица. Но непрерывное развёртывание на прод системах может быть нежелательным, т.к. может разрушить инфраструктуру из-за ошибки в коде. Непрерывное развертывание лучше использовать на тестовой среде, а в прод запускать только после контроля со стороны ответственного лица.

> *Какой из принципов IaaC является основополагающим?*

Основопологающим принципом IaaC является **идемпотентность** : т.е. способность операции которая при многократном вызове всегда воспроизводит один и тот же результат.

***

## Задание 2
 > *Чем Ansible выгодно отличается от других систем управление конфигурациями?*

Преимущества Ansible по сравнению с другими аналогичными решениями заключаются в следующем:
 + на управляемые узлы не нужно устанавливать никакого дополнительного ПО, всё работает через SSH (в случае необходимости дополнительные модули можно взять из официального репозитория);
 + код программы, написанный на Python, очень прост; при необходимости написание дополнительных модулей не составляет особого труда;
 + код программы, написанный на Python, очень прост; при необходимости написание дополнительных модулей не составляет особого труда;
 + низкий порог вхождения: обучиться работе с Ansible можно за очень короткое время;
 + документация к продукту написана очень подробно и вместе с тем — просто и понятно; она регулярно обновляется;
 + Ansible работает не только в режиме push, но и pull, как это делают большинство систем управления (Puppet, Chef);
 + имеется возможность последовательного обновления состояния узлов (rolling update).

 > *Какой, на ваш взгляд, метод работы систем конфигурации более надёжный — push или pull?*

В конечном счете, какая система соответствует рабочему процессу и владельцу в вашей организации ту и надо применять. Для управления малым парком машин лучше подходит push. Для управления большим (больше 500 машин) лучше подоёдет pull. Реализация не потребует больших мощностей для машины управления, но при pull реализации необходимы системы с агентами, что вызовет дополнительный расход ресурсов специалистов для подготовки машин.

***

## Задание 3
 *Установите на личный компьютер:*
 +  **VirtualBox**,
 +  **Vagrant**,
 +  **Terraform**,
 +  **Ansible**. 

```
netology@debian:~$ virtualboxvm -h
Oracle VM VirtualBox VM Runner v6.1.44
(C) 2005-2023 Oracle Corporation
All rights reserved.
```

```
netology@debian:~$ vagrant -v
Vagrant 2.2.14
```

```
netology@debian:~$ terraform --version
Terraform v1.4.6
on linux_amd64
```

```
netology@debian:~$ ansible --version
ansible 2.10.8
  config file = None
  configured module search path = ['/home/netology/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.9.2 (default, Feb 28 2021, 17:03:44) [GCC 10.2.1 20210110]
```
***

## Задание 4
 *Воспроизведите практическую часть лекции самостоятельно.*
 > *Создайте виртуальную машину.*

 > *Зайдите внутрь ВМ, убедитесь, что Docker установлен с помощью команды. \**docker ps\*\* *

```
netology@debian:~/vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-144-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Tue 16 May 2023 02:50:45 PM UTC

  System load:  0.07               Users logged in:          0
  Usage of /:   13.8% of 30.34GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 26%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.56.11
  Processes:    136

 * Introducing Expanded Security Maintenance for Applications.
   Receive updates to over 25,000 software packages with your
   Ubuntu Pro subscription. Free for personal use.

     https://ubuntu.com/pro


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Tue May 16 14:46:13 2023 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ docker -v
Docker version 23.0.6, build ef23cbc
vagrant@server1:~$ 
``` 

